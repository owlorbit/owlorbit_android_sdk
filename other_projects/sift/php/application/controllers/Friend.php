<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Friend extends CI_Controller {

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
		$this->load->model('friend_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');

		$this->load->model('notification_queue_model');
		$this->load->model('message_model');
		$this->load->model('user_model');
	}

	public function index(){

		$response = array(
		    'message' => 'Friend added!'
		);

		$this->output->set_output(json_encode_helper($response));		
	}

	public function all($pageIndex=1){
		$response = array();
		try{
			$pageIndex = intval($this->security->xss_clean(strip_tags($pageIndex)));

			if($pageIndex < 1){
				$pageIndex = 1;
			}

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

			$users = $this->friend_model->all($userId, $pageIndex);
			$response = array('message'=>'Friend accepted!',
				'users'=> $users);

		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}

	//decline_friend_request
	public function decline_friend_request(){
		$response = array();
		try{

			$userId = $this->security->xss_clean(strip_tags($this->input->post('userId')));
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

			$friendUserId = $this->user_session_model->getUserId($sessionToken);
			if($friendUserId == -1){
				$typeOfError = -2;
				throw new Exception("Session is invalid.");	
			}
			$this->friend_model->decline($userId, $friendUserId);

			$friendUser = $this->user_model->get_by_id($friendUserId);
			$type = "decline_friend";
			$msg = $friendUser->first_name." declined being friends with you.";
			$messageData = array(
				'message' => $msg,				
				'user_id' => $userId,
				'message_type' => $type
			);

			$messageId = $this->message_model->insert($messageData);			
			$this->notification_queue_model->add_no_room($messageId, $friendUserId, $userId, $type);

			$response = array('message'=>$msg);

		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}


	public function accept_friend_request(){
		$response = array();
		try{
			$userId = $this->security->xss_clean(strip_tags($this->input->post('userId')));
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

			$friendUserId = $this->user_session_model->getUserId($sessionToken);
			if($friendUserId == -1){
				$typeOfError = -2;
				throw new Exception("Session is invalid.");	
			}
			$this->friend_model->accept($userId, $friendUserId);

			$friendUser = $this->user_model->get_by_id($friendUserId);
			$type = "accept_friend";
			$msg = $friendUser->first_name." is now friends with you.";
			$messageData = array(
				'message' => $msg,				
				'user_id' => $userId,
				'message_type' => $type
			);
			$messageId = $this->message_model->insert($messageData);
			$this->notification_queue_model->add_no_room($messageId, $friendUserId, $userId, $type);


			$response = array('message'=>'Friend accepted!');

		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}

	public function pending_friends_you_sent($pageIndex=1){
		$response = array();
		try{
			$pageIndex = intval($this->security->xss_clean(strip_tags($pageIndex)));

			if($pageIndex < 1){
				$pageIndex = 1;
			}

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

			$users = $this->friend_model->pending_friends_you_sent($userId, $pageIndex);
			$response = array('message'=>'Attached is your pending user list you sent',
				'users'=> $users);
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}	

	public function pending_friends_they_sent($pageIndex=1){
		$response = array();
		try{
			$pageIndex = intval($this->security->xss_clean(strip_tags($pageIndex)));

			if($pageIndex < 1){
				$pageIndex = 1;
			}

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

			$users = $this->friend_model->pending_friends_they_sent($userId, $pageIndex);
			$response = array('message'=>'Attached is your pending user list you sent',
				'users'=> $users);
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}	

	public function add(){
		$response = array();
		try{
			//looking for
			$this->load->model('notification_queue_model');
			$this->load->model('message_model');
			$this->load->model('user_model');


			$this->validate();
			$friendUserId = $this->security->xss_clean(strip_tags($this->input->post('friendUserId')));
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

			if($userId == $friendUserId){
				throw new Exception("Id's are the same");
			}

			$data = array(
					'user_id' => $userId,
					'friend_user_id' => $friendUserId,
					'status' => 'pending'
				);

			$message = $this->friend_model->insert($data);

			$friendUser = $this->user_model->get_by_id($friendUserId);
			$type = "request_friend";
			$msg = $friendUser->first_name." requested being friends with you.";
			$messageData = array(
				'message' => $msg,				
				'user_id' => $userId,
				'message_type' => $type
			);
			$messageId = $this->message_model->insert($messageData);
			$this->notification_queue_model->add_no_room($messageId, $userId, $friendUserId, $type);

			$response = array('message' => $message);
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}

		$this->output->set_output(json_encode_helper($response));
	}

	public function remove(){
		$response = array();
		try{
			//looking for
			$this->load->model('notification_queue_model');
			$this->load->model('message_model');
			$this->load->model('user_model');

			$friendUserId = $this->security->xss_clean(strip_tags($this->input->post('userId')));
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

			if($userId == $friendUserId){
				throw new Exception("Id's are the same");
			}

			$this->friend_model->remove($userId, $friendUserId);
			$response = array('message' => "Successful");
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}

		$this->output->set_output(json_encode_helper($response));
	}


	public function get(){
	}

	private function validate(){
        
        $this->form_validation->set_rules('friendUserId', 'First Name', 'required|trim|max_length[255]');        

        if($this->form_validation->run()){
            return true;
        }
        
        throw new Exception(validation_errors());
    }	
}
