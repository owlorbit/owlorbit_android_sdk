<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Room extends CI_Controller {

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
		$this->load->model('message_model');
		$this->load->model('friend_model');
		$this->load->model('room_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');
	}

	public function index(){
		$response = array(
		    'message' => 'Message added!'
		);
		$this->output->set_output(json_encode_helper($response));		
	}

	public function attribute(){
		$response = array();
		try{

			$roomId = $this->security->xss_clean(strip_tags($this->input->post('roomId')));
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
		    
		    $roomAttributes = $this->room_model->attribute($userId, $roomId);
			$response = array(
		    	'message' => 'room attributes included!',		    	
		    	'room_attributes' => $roomAttributes	
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);		
	}

	//get_all_only_rooms
	public function get_all_only_rooms(){
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

		    $rooms = $this->room_model->load_all_only_rooms($userId);		    

			$response = array(
		    	'message' => 'rooms returned!',
		    	'rooms' => $rooms
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}

		error_log("flarv". json_encode_helper($response));
		echo json_encode_helper($response);
	}	

	public function get_all(){
		$typeOfError = 0;
		$response = array();
		try{		
			$publicKey = $this->security->xss_clean(strip_tags($this->input->post('publicKey')));
			$encryptedSession = $this->security->xss_clean(strip_tags($this->input->post('encryptedSession')));
			$sessionHash = $this->security->xss_clean(strip_tags($this->input->post('sessionHash')));
			$sessionToken = $this->verify_session->isValidSession($encryptedSession, $publicKey, $sessionHash);

			error_log("public key".$publicKey);
			error_log("session token".$sessionToken);
			error_log("session hash".$sessionHash);
			error_log("session encryptedSession".$encryptedSession);

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

		    $users = $this->room_model->load_all($userId);
		    $rooms = $this->room_model->load_rooms($userId);

			$response = array(
		    	'message' => 'rooms returned!',
		    	'users' => $users,
		    	'rooms' => $rooms
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'error_code' => $typeOfError,
				'successful'=> false);
		}

		error_log("flarv". json_encode_helper($response));
		echo json_encode_helper($response);
	}	

	public function get_recent($pageIndex=1){
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

		    $lastMessageOfRooms = $this->room_model->all($userId, $pageIndex);

			$response = array(
		    	'message' => 'rooms returned!',		    	
		    	'rooms' => $lastMessageOfRooms		    	
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),				
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}

	public function accept(){
		$response = array();
		try{
			$roomId = $this->security->xss_clean(strip_tags($this->input->post('roomId')));			
			
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
		    $this->room_model->accept_room($userId, $roomId);
		    $this->message_model->clear_accept($userId, $roomId);

		    error_log($this->db->last_query());

			$response = array(
		    	'message' => 'Joins Room',
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}

	public function leave(){
		$response = array();
		try{
			$roomId = $this->security->xss_clean(strip_tags($this->input->post('roomId')));			
			
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
		    $this->room_model->leave_room($userId, $roomId);
		    $this->message_model->clear_accept($userId, $roomId);

			$response = array(
		    	'message' => 'Left Room',
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}


	public function set_hidden(){
		$response = array();
		try{
			$this->load->model('notification_queue_model');
			$this->load->model('message_model');
			$this->load->model('user_model');

			$roomId = $this->security->xss_clean(strip_tags($this->input->post('roomId')));			
			
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
		    $this->room_model->set_hidden($userId, $roomId);


		    /*
		    $user = $this->user_model->get_by_id($userId);
		    $type = "visibility";
		    $meetupMsg = $user->first_name." just became hidden.";
			$messageData = array(
				'message' => $meetupMsg,	
				'room_id' => $roomId,			
				'user_id' => $userId,
				'message_type' => $type
			);

		    $messageId = $this->message_model->insert($messageData);		    
		    $this->notification_queue_model->add($roomId, $messageId, $userId, $type);
		    */




			$response = array(
		    	'message' => 'set hidden',
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}	

	public function set_visible(){
		$response = array();
		try{
			$this->load->model('notification_queue_model');
			$this->load->model('message_model');
			$this->load->model('user_model');
			
			$roomId = $this->security->xss_clean(strip_tags($this->input->post('roomId')));			
			
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
		    $this->room_model->set_visible($userId, $roomId);

		    /*
		    $user = $this->user_model->get_by_id($userId);
		    $type = "visibility";
		    $meetupMsg = $user->first_name." just became visible.";
			$messageData = array(
				'message' => $meetupMsg,	
				'room_id' => $roomId,			
				'user_id' => $userId,
				'message_type' => $type
			);

		    $messageId = $this->message_model->insert($messageData);		    
		    $this->notification_queue_model->add($roomId, $messageId, $userId, $type);
		    */


			$response = array(
		    	'message' => 'set visible',
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}	


	public function get($roomId=-1){
		$response = array();
		try{
			$roomId = intval($this->security->xss_clean(strip_tags($roomId)));

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

		    $lastMessageOfRooms = $this->room_model->get_room($userId, $roomId);
			$response = array(
		    	'message' => 'room attribute!',		    	
		    	'rooms' => $lastMessageOfRooms		    	
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}	
}

?>