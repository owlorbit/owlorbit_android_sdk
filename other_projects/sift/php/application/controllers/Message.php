<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Message extends CI_Controller {

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
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');
	}

	public function index(){
		$response = array(
		    'message' => 'Message added!'
		);
		$this->output->set_output(json_encode_helper($response));		
	}

	public function get_recent($pageIndex=1){
		$response = array();
		try{
			$pageIndex = intval($this->security->xss_clean(strip_tags($pageIndex)));
			if($pageIndex < 1){
				$pageIndex = 1;
			}

			$userIds = $this->security->xss_clean($_POST['userIds']);
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
			//array_push($userIds, $userId);
		    $roomId = $this->message_model->initiate_room($userId, $userIds);

			$response = array(
		    	'message' => 'room initiated added!',
		    	'room_id' => $roomId
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}
	public function init(){

		$response = array();
		try{

			//$this->validate();
			//$longitude = $this->security->xss_clean(strip_tags($this->input->post('longitude')));
			//$latitude = $this->security->xss_clean(strip_tags($this->input->post('latitude')));
			if(!isset($_POST['userIds'])){
				throw new Exception("Users were not sent!");
			}

			$userIds = $this->security->xss_clean($_POST['userIds']);
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
			//array_push($userIds, $userId);
		    $roomId = $this->message_model->initiate_room($userId, $userIds);

			$response = array(
		    	'message' => 'room initiated added!',
		    	'room_id' => $roomId
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}

}

?>