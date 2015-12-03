<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed'); // This Prevents browsers from directly accessing this PHP file.

//first decrypt with public key
//then decrypt with private key...
//save result as session token

//returns -1 if public key is invalid.. the user should log-in again to get a new public key.
//returns -2 if session is invalid..

class Verify_Session{

	public function isValidSession($encryptedSession, $publicKey, $sessionHash)
	{
	  $ci =& get_instance();

	  $ci->load->library('encryption_lib');
	  $ci->load->model('core/user_token_model');
	  $ci->load->model('core/user_session_model');

	  $userToken = $ci->user_token_model->get(array('public_key' => $publicKey));

      if($userToken->num_rows() > 0){
		$userToken = $userToken->row(0);
	  }else{
		return -1;
	  }

	  $sessionToken = $ci->encryption_lib->decrypt($ci->encryption_lib->decrypt($encryptedSession, $userToken->private_key), $publicKey);
	  
	  //return $sessionToken;
	  //return hash('sha256', $sessionToken);
      if(hash('sha256', $sessionToken) != $sessionHash){
	  	return -2;
	  }

	  //if it passes those checks that means it's valid..
	  return $sessionToken;	 
	}		
}