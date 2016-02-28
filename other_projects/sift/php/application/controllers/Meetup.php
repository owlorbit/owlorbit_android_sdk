<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Meetup extends CI_Controller {

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
		$this->load->model('meetup_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');		
	}

	public function index(){
		echo "meetup";	
	}

	public function get_all_locations(){	
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

		    $allLocationsInRoom = $this->location_model->get_all_standard_locations_in_room($userId, $roomId);
			$response = array(
		    	'message' => 'room locations',		    	
		    	'user_locations' => $allLocationsInRoom
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);	

	}

	public function add(){
		$response = array();
		try{
			$this->load->model('notification_queue_model');
			$this->load->model('message_model');
			$this->load->model('user_model');

			$this->validate();

			$title = $this->security->xss_clean(strip_tags($this->input->post('title')));
			$subtitle = $this->security->xss_clean(strip_tags($this->input->post('subtitle')));
			$roomId = $this->security->xss_clean(strip_tags($this->input->post('roomId')));
			$isGlobal = $this->security->xss_clean(strip_tags($this->input->post('isGlobal')));

			$longitude = $this->security->xss_clean(strip_tags($this->input->post('longitude')));
			$latitude = $this->security->xss_clean(strip_tags($this->input->post('latitude')));
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
		    $this->meetup_model->insert_entry($userId);
		    $user = $this->user_model->get_by_id($userId);

		    $type = "meetup";
		    $meetupMsg = $title." pin created by ".$user->first_name;
			$messageData = array(
				'message' => $meetupMsg,	
				'room_id' => $roomId,			
				'user_id' => $userId,
				'message_type' => $type
			);

		    $messageId = $this->message_model->insert($messageData);		    
		    $this->notification_queue_model->add($roomId, $messageId, $userId, $type);

			$response = array(
		    	'message' => 'meetup added!',
		    	'meetup_id' => $this->db->insert_id()
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}

	public function update(){
		$response = array();
		try{


			$meetupId = $this->security->xss_clean(strip_tags($this->input->post('meetupId')));	
			$longitude = $this->security->xss_clean(strip_tags($this->input->post('longitude')));
			$latitude = $this->security->xss_clean(strip_tags($this->input->post('latitude')));
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

		    $this->meetup_model->update($meetupId, $userId, $longitude, $latitude);

			$response = array(
		    	'message' => 'meetup updated!'
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);		
	}


	public function disable(){
		$response = array();
		try{

			$meetupId = $this->security->xss_clean(strip_tags($this->input->post('meetupId')));				
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

		    $this->meetup_model->disable($meetupId, $userId);

			$response = array(
		    	'message' => 'meetup updated!'
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);		
	}	

	private function validate(){
        
        /*$this->form_validation->set_rules('longitude', 'Longitude', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('latitude', 'Latitude', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('device_id', 'Device Id', 'required|trim|max_length[255]');

        if($this->form_validation->run()){
            return true;
        }
        
        throw new Exception(validation_errors());*/
        return true;
    }	
}
