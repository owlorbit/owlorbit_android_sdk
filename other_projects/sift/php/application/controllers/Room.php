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