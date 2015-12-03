
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class User extends CI_Controller {

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/index.php/welcome
	 *	- or -
	 * 		http://example.com/index.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /index.php/welcome/<method_name>
	 * @see http://codeigniter.com/user_guide/general/urls.html
	 */
	public function __construct(){
		parent::__construct();	
		$this->output->set_header('Content-Type: application/json; charset=utf-8');	
		$this->load->helper('json_encode_helper');
		$this->load->library('verify_session');
		$this->load->model('user_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');
	}

	public function index(){

		$response = array(
		    'message' => 'User added!'
		);

		$this->output->set_output(json_encode_helper($response));		
	}

	public function find($value, $pageIndex=1){
		$response = array();
		try{
			$pageIndex = intval($this->security->xss_clean(strip_tags($pageIndex)));

			if($pageIndex < 1){
				$pageIndex = 1;
			}
			$value = $this->security->xss_clean(strip_tags(urldecode($value)));
			$users = $this->user_model->find($value,$pageIndex);
			$response = array('message'=>'Attached is your user list',
				'users'=> $users);
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'hasFailed'=> true);
		}
		$this->output->set_output(json_encode_helper($response));
	}

	public function upload_profile_img(){
		$response = array();
		try{

			$publicKey = $this->security->xss_clean(strip_tags($this->input->post('publicKey')));
			$encryptedSession = $this->security->xss_clean(strip_tags($this->input->post('encryptedSession')));
			$sessionHash = $this->security->xss_clean(strip_tags($this->input->post('sessionHash')));
			$sessionToken = $this->verify_session->isValidSession($encryptedSession, $publicKey, $sessionHash);
		
			if($sessionToken == -1){
				$typeOfError = -1;
				throw new Exception("Public key is invalid.");
			}else if ($sessionToken == -2){
				$typeOfError = -2;
				throw new Exception("Session is invalid.");
			}

			$userId = $this->user_session_model->getUserId($sessionToken);
			if($userId == -1){
				$typeOfError = -2;
				throw new Exception("Session is invalid.");	
			}

			$urlPath = '/uploads/profile_imgs/'.$userId.'.png';
			$targetPath = $_SERVER['DOCUMENT_ROOT'].$urlPath;
			move_uploaded_file($_FILES["file"]["tmp_name"], $targetPath );
			$this->user_model->update_avatar($userId, $urlPath);

			$response = array('message'=>'img uploaded..',
				'original_avatar' => $urlPath);
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'hasFailed'=> true);
		}

		
		

		$this->output->set_output(json_encode_helper($response));
	}

	public function add(){		
		$response = array();
		try{
		    if($this->add_validate()){
		    	$this->user_model->insert_entry();
		    }
			$email = $this->security->xss_clean(strip_tags($this->input->post('email')));		    
		    $timestamp = time();
			$user = $this->user_model->get(array('email' => $email));
			if($user->num_rows() > 0){
				$userId = $user->row(0)->id;
			}else{
				throw new Exception("Error retrieving user_id");
			}

			if($this->user_token_model->isPublicTokenActive($userId)){
				$userToken = $this->user_token_model->get(array('userId' => $userId))->row(0);
				$publicKey = $userToken->publicKey;
				$privateKey = $userToken->privateKey;
			}else{
				$publicKey = hash('sha256', $email.$this->config->item('public_salt').$timestamp);
				$privateKey = hash('sha256', $publicKey.$this->config->item('private_salt').$timestamp);
				$expires = date('Y-m-d 23:59:59', strtotime('+30 days', time()));
				$userTokenData = array(
						'expires' => $expires,
						'public_key' => $publicKey,
						'private_key' => $privateKey,
						'user_id' => $userId
					);

				$this->user_token_model->insert($userTokenData);
			}

			$sessionToken = hash('sha256', $privateKey.$this->config->item('session_salt').$timestamp);
			$sessionData = array(
					'session_token' => $sessionToken,
					'user_id' => $userId,
					'expires' => date('Y-m-d 23:59:59', strtotime('+1 days', time()))
				);

			$this->user_session_model->insert($sessionData);
			$response = array(
		    	'message' => 'User added!',
		    	'publicKey' => $publicKey,
				'privateKey' => $privateKey,
				'userId' => $userId,
				'sessionToken' => $sessionToken
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'hasFailed'=> true);
		}

		$this->output->set_output(json_encode_helper($response));
	}

	public function get(){
	}

	private function add_validate(){

        $this->form_validation->set_rules('email', 'Email', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('first_name', 'First Name', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('last_name', 'Last Name', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('password', 'Password', 'required|trim|max_length[255]');

        if($this->form_validation->run()){
            return true;
        }
        
        throw new Exception(validation_errors());
    }	
}
