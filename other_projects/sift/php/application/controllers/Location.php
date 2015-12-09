<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Location extends CI_Controller {

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
		$this->load->model('location_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');		
	}

	public function index(){
		echo "location";	
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
		    
		    $allLocationsInRoom = $this->location_model->get_all_locations_in_room($userId, $roomId);
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

			$this->validate();
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
		    $this->location_model->insert_entry($userId);

			$response = array(
		    	'message' => 'Location added!'
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		echo json_encode_helper($response);
	}

	public function get(){
	}

	private function validate(){
        
        $this->form_validation->set_rules('longitude', 'Longitude', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('latitude', 'Latitude', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('device_id', 'Device Id', 'required|trim|max_length[255]');

        if($this->form_validation->run()){
            return true;
        }
        
        throw new Exception(validation_errors());
    }	
}
