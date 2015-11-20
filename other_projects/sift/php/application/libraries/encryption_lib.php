<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); // This Prevents browsers from directly accessing this PHP file.

class Encryption_Lib{
	
	private $DEFAULT_SCHEMA_VERSION = 3;

	protected $_settings;

	public function __construct() {
		if (!extension_loaded('mcrypt')) {
			throw new \Exception('The mcrypt extension is missing.');
		}
	}

	protected function _configureSettings($version) {

		$settings = new \stdClass();

		$settings->algorithm = MCRYPT_RIJNDAEL_128;
		$settings->saltLength = 8;
		$settings->ivLength = 16;

		$settings->pbkdf2 = new \stdClass();
		$settings->pbkdf2->prf = 'sha1';
		$settings->pbkdf2->iterations = 10000;
		$settings->pbkdf2->keyLength = 32;
		
		$settings->hmac = new \stdClass();
		$settings->hmac->length = 32;

		switch ($version) {
			case 0:
				$settings->mode = 'ctr';
				$settings->options = 0;
				$settings->hmac->includesHeader = false;
				$settings->hmac->algorithm = 'sha1';
				$settings->hmac->includesPadding = true;
				$settings->truncatesMultibytePasswords = true;
				break;

			case 1:
				$settings->mode = 'cbc';
				$settings->options = 1;
				$settings->hmac->includesHeader = false;
				$settings->hmac->algorithm = 'sha256';
				$settings->hmac->includesPadding = false;
				$settings->truncatesMultibytePasswords = true;
				break;

			case 2:
				$settings->mode = 'cbc';
				$settings->options = 1;
				$settings->hmac->includesHeader = true;
				$settings->hmac->algorithm = 'sha256';
				$settings->hmac->includesPadding = false;
				$settings->truncatesMultibytePasswords = true;
				break;

			case 3:
				$settings->mode = 'cbc';
				$settings->options = 1;
				$settings->hmac->includesHeader = true;
				$settings->hmac->algorithm = 'sha256';
				$settings->hmac->includesPadding = false;
				$settings->truncatesMultibytePasswords = false;
				break;

			default:
				throw new \Exception('Unsupported schema version ' . $version);
		}

		$this->_settings = $settings;
	}

	/**
	 * Encrypt or decrypt using AES CTR Little Endian mode
	 */
	protected function _aesCtrLittleEndianCrypt($payload, $key, $iv) {

		$numOfBlocks = ceil(strlen($payload) / strlen($iv));
		$counter = '';
		for ($i = 0; $i < $numOfBlocks; ++$i) {
			$counter .= $iv;

			// Yes, the next line only ever increments the first character
			// of the counter string, ignoring overflow conditions.  This
			// matches CommonCrypto's behavior!
			$iv[0] = chr(ord($iv[0]) + 1);
		}

		return $payload ^ mcrypt_encrypt($this->_settings->algorithm, $key, $counter, 'ecb');
	}

	protected function _generateHmac(\stdClass $components, $hmacKey) {
	
		$hmacMessage = '';
		if ($this->_settings->hmac->includesHeader) {
			$hmacMessage .= $components->headers->version
							. $components->headers->options
							. (isset($components->headers->encSalt) ? $components->headers->encSalt : '')
							. (isset($components->headers->hmacSalt) ? $components->headers->hmacSalt : '')
							. $components->headers->iv;
		}

		$hmacMessage .= $components->ciphertext;

		$hmac = hash_hmac($this->_settings->hmac->algorithm, $hmacMessage, $hmacKey, true);

		if ($this->_settings->hmac->includesPadding) {
			$hmac = str_pad($hmac, $this->_settings->hmac->length, chr(0));
		}
	
		return $hmac;
	}

	/**
	 * Key derivation -- This method is intended for testing.  It merely
	 * exposes the underlying key-derivation functionality.
	 */
	public function generateKey($salt, $password) {		
		$this->_configureSettings($this->DEFAULT_SCHEMA_VERSION);
		return $this->_generateKey($salt, $password);
	}

	protected function _generateKey($salt, $password) {

		if ($this->_settings->truncatesMultibytePasswords) {
			$utf8Length = mb_strlen($password, 'utf-8');
			$password = substr($password, 0, $utf8Length);
		}

		return $this->hash_pbkdf2($this->_settings->pbkdf2->prf, $password, $salt, $this->_settings->pbkdf2->iterations, $this->_settings->pbkdf2->keyLength, true);
	}


	public function decrypt($encryptedBase64Data, $password) {

		$components = $this->_unpackEncryptedBase64Data($encryptedBase64Data);

		if (!$this->_hmacIsValid($components, $password)) {
			return false;
		}

		$key = $this->_generateKey($components->headers->encSalt, $password);

		switch ($this->_settings->mode) {
			case 'ctr':
				$plaintext = $this->_aesCtrLittleEndianCrypt($components->ciphertext, $key, $components->headers->iv);
				break;

			case 'cbc':
				$paddedPlaintext = mcrypt_decrypt($this->_settings->algorithm, $key, $components->ciphertext, 'cbc', $components->headers->iv);
				$plaintext = $this->_stripPKCS7Padding($paddedPlaintext);
				break;
		}

		return $plaintext;
	}
	

	private function hash_pbkdf2($algorithm, $password, $salt, $count, $key_length = 0, $raw_output = false)
	{
	  $algorithm = strtolower($algorithm);
	  if(!in_array($algorithm, hash_algos(), true))
	    die('PBKDF2 ERROR: Invalid hash algorithm.');
	  if($count <= 0 || $key_length <= 0)
	    die('PBKDF2 ERROR: Invalid parameters.');
	
	  $hash_length = strlen(hash($algorithm, "", true));
	  $block_count = ceil($key_length / $hash_length);
	
	  $output = "";
	  for($i = 1; $i <= $block_count; $i++) {
	        // $i encoded as 4 bytes, big endian.
	    $last = $salt . pack("N", $i);
	        // first iteration
	    $last = $xorsum = hash_hmac($algorithm, $last, $password, true);
	        // perform the other $count - 1 iterations
	    for ($j = 1; $j < $count; $j++) {
	      $xorsum ^= ($last = hash_hmac($algorithm, $last, $password, true));
	    }
	    $output .= $xorsum;
	  }
	
	  if($raw_output)
	    return substr($output, 0, $key_length);
	  else
	    return bin2hex(substr($output, 0, $key_length));
	}


	private function _unpackEncryptedBase64Data($encryptedBase64Data) {
		$binaryData = base64_decode($encryptedBase64Data);
		$components = new \stdClass();
		$components->headers = $this->_parseHeaders($binaryData);
		$components->hmac = substr($binaryData, - $this->_settings->hmac->length);
		$headerLength = $components->headers->length;
		$components->ciphertext = substr($binaryData, $headerLength, strlen($binaryData) - $headerLength - strlen($components->hmac));
		return $components;
	}
	private function _parseHeaders($binData) {
		$offset = 0;
		if($binData){
			$versionChr = $binData[0];
		}else{
			$versionChr = "";
		}
		$offset += strlen($versionChr);
		$this->_configureSettings($this->DEFAULT_SCHEMA_VERSION);

		if(strlen($binData) > 1){
			$optionsChr = $binData[1];
		}else{
			$optionsChr = "";
		}
		$offset += strlen($optionsChr);
		$encSalt = substr($binData, $offset, $this->_settings->saltLength);
		$offset += strlen($encSalt);
		$hmacSalt = substr($binData, $offset, $this->_settings->saltLength);
		$offset += strlen($hmacSalt);
		$iv = substr($binData, $offset, $this->_settings->ivLength);
		$offset += strlen($iv);
		$headers = (object)array(
			'version' => $versionChr,
			'options' => $optionsChr,
			'encSalt' => $encSalt,
			'hmacSalt' => $hmacSalt,
			'iv' => $iv,
			'length' => $offset
		);
		return $headers;
	}
	private function _stripPKCS7Padding($plaintext) {
		$padLength = ord($plaintext[strlen($plaintext)-1]);
		return substr($plaintext, 0, strlen($plaintext) - $padLength);
	}
	private function _hmacIsValid($components, $password) {
		$hmacKey = $this->_generateKey($components->headers->hmacSalt, $password);
		return ($components->hmac == $this->_generateHmac($components, $hmacKey));
	}

	public function encrypt($plaintext, $password) {
		$version =  $this->DEFAULT_SCHEMA_VERSION;
		$this->_configureSettings($version);

		$components = $this->_generateInitializedComponents($version);
		$components->headers->encSalt = $this->_generateSalt();
		$components->headers->hmacSalt = $this->_generateSalt();
		$components->headers->iv = $this->_generateIv($this->_settings->ivLength);

		$encKey = $this->_generateKey($components->headers->encSalt, $password);
		$hmacKey = $this->_generateKey($components->headers->hmacSalt, $password);

		return $this->_encrypt($plaintext, $components, $encKey, $hmacKey);
	}

	public function encryptWithArbitrarySalts($plaintext, $password, $encSalt, $hmacSalt, $iv) {
		$version = $this->DEFAULT_SCHEMA_VERSION;
		$this->_configureSettings($version);

		$components = $this->_generateInitializedComponents($version);
		$components->headers->encSalt = $encSalt;
		$components->headers->hmacSalt = $hmacSalt;
		$components->headers->iv = $iv;

		$encKey = $this->_generateKey($components->headers->encSalt, $password);
		$hmacKey = $this->_generateKey($components->headers->hmacSalt, $password);

		return $this->_encrypt($plaintext, $components, $encKey, $hmacKey);
	}

	public function encryptWithArbitraryKeys($plaintext, $encKey, $hmacKey, $iv) {
		$version = $this->DEFAULT_SCHEMA_VERSION;
		$this->_configureSettings($version);

		$this->_settings->options = 0;

		$components = $this->_generateInitializedComponents($version);
		$components->headers->iv = $iv;

		return $this->_encrypt($plaintext, $components, $encKey, $hmacKey);
	}

	private function _generateInitializedComponents($version) {

		$components = new \stdClass();
		$components->headers = new \stdClass();
		$components->headers->version = chr($version);
		$components->headers->options = chr($this->_settings->options);

		return $components;
	}

	private function _encrypt($plaintext, \stdClass $components, $encKey, $hmacKey) {
	
		switch ($this->_settings->mode) {
			case 'ctr':
				$components->ciphertext = $this->_aesCtrLittleEndianCrypt($plaintext, $encKey, $components->headers->iv);
				break;
	
			case 'cbc':
				$paddedPlaintext = $this->_addPKCS7Padding($plaintext, strlen($components->headers->iv));
				$components->ciphertext = mcrypt_encrypt($this->_settings->algorithm, $encKey, $paddedPlaintext, 'cbc', $components->headers->iv);
				break;
		}

		$binaryData = ''
				. $components->headers->version
				. $components->headers->options
				. (isset($components->headers->encSalt) ? $components->headers->encSalt : '')
				. (isset($components->headers->hmacSalt) ? $components->headers->hmacSalt : '')
				. $components->headers->iv
				. $components->ciphertext;
	
		$hmac = $this->_generateHmac($components, $hmacKey);
	
		return base64_encode($binaryData . $hmac);
	}

	private function _addPKCS7Padding($plaintext, $blockSize) {
		$padSize = $blockSize - (strlen($plaintext) % $blockSize);
		return $plaintext . str_repeat(chr($padSize), $padSize);
	}

	private function _generateSalt() {
		return $this->_generateIv($this->_settings->saltLength);
	}

	private function _generateIv($blockSize) {
		if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
			$randomSource = MCRYPT_RAND;
		} else {
			$randomSource = MCRYPT_DEV_URANDOM;
		}
		return mcrypt_create_iv($blockSize, $randomSource);
	}

}