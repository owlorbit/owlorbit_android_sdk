<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Notification extends CI_Controller {

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

		//$this->output->set_header('Content-Type: application/json; charset=utf-8');	
		$this->load->helper('json_encode_helper');
		$this->load->library('verify_session');
		$this->load->model('user_model');

		$this->load->model('user_token_model');
		$this->load->model('user_session_model');
		$this->load->model('notification_model');
	}

	public function index(){

		$this->load->library('parse-php-sdk/src/Parse/ParseClient');		
		
		$this->load->library('parse-php-sdk/src/Parse/ParseObject');		
		$this->load->library('parse-php-sdk/src/Parse/ParsePush');	

		$this->load->library('parse-php-sdk/src/Parse/ParseInstallation');	
		$this->load->library('parse-php-sdk/src/Parse/ParseQuery');	

		//$this->parseclient->initialize( "mmuRcbOhsjLPCFPv81ZO8HWVhn1YcIb8F93e05ZN", "fURuXJR5xjG7p2B7AqdKANUJVwb9pko4y4n3zi7o", "eyGXoKU8PTTeXYXJdSY9BonQu3gZEv9sv7x1Yrcu" );				
		ParseClient::initialize('mmuRcbOhsjLPCFPv81ZO8HWVhn1YcIb8F93e05ZN', 'zMVFPm0zShj7pxFjlpGGhOoi0BwYtZzmKXNQVqAP', 'eyGXoKU8PTTeXYXJdSY9BonQu3gZEv9sv7x1Yrcu');
		ParseClient::setServerURL('https://parseapi.back4app.com');
		// Push to Channels

		//$data = array("alert" => "FUCK SHIT");
		$query = ParseInstallation::query();
		$query->equalTo("objectId", "VYOSdWQVGz");

		ParsePush::send(array(
		    "where" => $query,
		    "data" => $data
		));

		$response = array(
		    'message' => 'Message added!'
		);
		$this->output->set_output(json_encode_helper($response));		
	}


	//check the existing registered devices..
	//then submit to Parse the message.
	//message should contain..
	//roomname, sender name, message
	public function process_notifications(){
		
		if($this->isLocalServer()){
			//make sure only localhost calling this method..
			$this->load->library('parse-php-sdk/src/Parse/ParseClient');
			$this->load->library('parse-php-sdk/src/Parse/ParseObject');
			$this->load->library('parse-php-sdk/src/Parse/ParsePush');

			$this->load->library('parse-php-sdk/src/Parse/ParseInstallation');
			$this->load->library('parse-php-sdk/src/Parse/ParseQuery');	

			$this->load->model('notification_queue_model');
			ParseClient::initialize('mmuRcbOhsjLPCFPv81ZO8HWVhn1YcIb8F93e05ZN', 'zMVFPm0zShj7pxFjlpGGhOoi0BwYtZzmKXNQVqAP', 'eyGXoKU8PTTeXYXJdSY9BonQu3gZEv9sv7x1Yrcu');
			ParseClient::setServerURL('https://parseapi.back4app.com');

			$notificationQueueWithRoom = $this->notification_queue_model->get_not_sent();
			$notificationQueueWithNoRoom = $this->notification_queue_model->get_not_sent_no_room();

			foreach ($notificationQueueWithRoom as $notification){

				$message = "";
				if($notification->message_type == "text"){
					$message = ucfirst ($notification->first_name)." ".ucfirst($notification->last_name[0]).". says:";
					$message .= "\n";
				}

				$message .= $notification->message;

				$data = array("alert" => $message, 
					"message_id" => $notification->message_id,
					"room_id" => $notification->room_id,
					"created" => $notification->message_created,
					"user_id" => $notification->user_id,
					"message_type" => $notification->message_type,
					"first_name" => $notification->first_name,
					"last_name" => $notification->last_name);
				$query = ParseInstallation::query();
				$query->equalTo("deviceToken", $notification->device_id);

				ParsePush::send(array(
				    "where" => $query,
				    "data" => $data
				));

				$this->notification_queue_model->update_sent_status($notification->id);			
			}


			foreach ($notificationQueueWithNoRoom as $notification){

				$message = $notification->message;
				$data = array("alert" => $message, 
					"message_id" => $notification->message_id,					
					"created" => $notification->message_created,
					"user_id" => $notification->user_id,
					"message_type" => $notification->message_type,
					"first_name" => $notification->first_name,
					"last_name" => $notification->last_name);
				$query = ParseInstallation::query();
				$query->equalTo("deviceToken", $notification->device_id);

				ParsePush::send(array(
				    "where" => $query,
				    "data" => $data
				));

				$this->notification_queue_model->update_sent_status($notification->id);			
			}

			$response = array(
			    'message' => 'Message added!'
			);
			$this->output->set_output(json_encode_helper($response));
		}
	}

	public function test_curl(){
		session_write_close();

		$ch = curl_init();


        $data = ['app_id' => "6593a224-cbe7-4bf1-988d-430cec831bbf",
                 'contents' => ["en"=> "New incident: awefaewf"],
                 'headings' => ["en"=> "test"],
                 'isSafari' => true,
                 'isAnyWeb' => true,
                 'included_segments' => ['Key Decision Maker'],
                 'data' => ['incidentId' => "...."
                            ]];

        $fields = json_encode($data);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json',
        'Authorization: Basic MDg5NTk1NGMtMjAzZS00NjFjLTg2Y2ItNzFlNTM0ZTU5Yzcx']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        curl_setopt($ch, CURLOPT_HEADER, FALSE);
        curl_setopt($ch, CURLOPT_POST, TRUE);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
        $response = curl_exec($ch);
        curl_close($ch);		


		echo "heyzz";
	}

	public function process_onesignal_notifications(){
		$this->load->model('notification_queue_model');

		if($this->isLocalServer()){
			session_write_close();
			try{
				$ONESIGNAL_REST_KEY = "MDg5NTk1NGMtMjAzZS00NjFjLTg2Y2ItNzFlNTM0ZTU5Yzcx";
				$ONESIGNAL_APP_KEY = "6593a224-cbe7-4bf1-988d-430cec831bbf";

				$notificationQueueWithRoom = $this->notification_queue_model->get_not_sent();
				$notificationQueueWithNoRoom = $this->notification_queue_model->get_not_sent_no_room();


				foreach ($notificationQueueWithRoom as $notification){

					$message = "";
					$notificationMsg = "";
					if($notification->message_type == "text"){
						$notificationMsg = ucfirst ($notification->first_name)." ".ucfirst($notification->last_name[0]).". says:";
						$notificationMsg .= "\n";
						$message .= $notification->message;
					}else if($notification->message_type == "meetup"){
						$notificationMsg = ucfirst ($notification->first_name)." ".ucfirst($notification->last_name[0])." has created a meetup point.";
						$notification->message = 'Meetup up point created.';
					}

					$headerMsg = ucfirst ($notification->first_name)." ".ucfirst($notification->last_name[0]);
					
					$data = array("alert" => $message, 
						"message_id" => $notification->message_id,
						"room_id" => $notification->room_id,
						"created" => $notification->message_created,
						"user_id" => $notification->user_id,
						"message_type" => $notification->message_type,
						"first_name" => $notification->first_name,
						"last_name" => $notification->last_name,
						"app_id" => $ONESIGNAL_APP_KEY
						);

					$content = array(
					  "en" => $notification->message
					  );

					$fields = array(
					  'app_id' => $ONESIGNAL_APP_KEY,					  
					  'data' => $data,
					  "include_player_ids" => array($notification->device_id),
					  "ios_badgeType" => "SetTo",
                	  "ios_badgeCount" => "1",                	  
                	  "small_icon" => "onesignal_receive_icon",
                	  "large_icon" => "owlorbit_icon",
                	  "contents" => array("en" => $notification->message),
                	  "headings" => array("en" => $headerMsg),
					  'contents' => $content
					);

					$fields = json_encode($fields);
				    $ch = curl_init();
				    curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
				    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json',
				                           'Authorization: Basic '.$ONESIGNAL_REST_KEY));
				    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
				    curl_setopt($ch, CURLOPT_HEADER, FALSE);
				    curl_setopt($ch, CURLOPT_POST, TRUE);
				    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
				    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    
				  	if(curl_exec($ch)){
				  		curl_close($ch);				  		
				  		$this->notification_queue_model->update_sent_status($notification->id);
				    	continue; // ?? - go to the next loop
				  	}
				}

				foreach ($notificationQueueWithNoRoom as $notification){

					$message = "";
					$notificationMsg = "";
					if($notification->message_type == "request_friend"){
						$notificationMsg = "Friend Request!\n";						
						$message .= $notification->message;
					}else if($notification->message_type == "accept_friend"){
						//accept_friend
						$notificationMsg = "Friend Accepted!\n";						
						$message .= $notification->message;
					}

					$headerMsg = ucfirst ($notification->first_name)." ".ucfirst($notification->last_name[0]);

					$data = array("alert" => $message, 
						"message_id" => $notification->message_id,						
						"created" => $notification->message_created,
						"user_id" => $notification->user_id,
						"message_type" => $notification->message_type,
						"first_name" => $notification->first_name,
						"last_name" => $notification->last_name,
						"app_id" => $ONESIGNAL_APP_KEY
						);

					$content = array(
					  "en" => $notificationMsg.$message
					  );

					$fields = array(
					  'app_id' => $ONESIGNAL_APP_KEY,					  
					  'data' => $data,
					  "include_player_ids" => array($notification->device_id),
					  "ios_badgeType" => "SetTo",
                	  "ios_badgeCount" => "1",                	  
                	  "small_icon" => "onesignal_receive_icon",
                	  "large_icon" => "owlorbit_icon",
                	  "contents" => array("en" => $headerMsg),
                	  "headings" => array("en" => $notificationMsg),
					  'contents' => $content
					);

					$fields = json_encode($fields);
				    $ch = curl_init();
				    curl_setopt($ch, CURLOPT_URL, "https://onesignal.com/api/v1/notifications");
				    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json',
				                           'Authorization: Basic '.$ONESIGNAL_REST_KEY));
				    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
				    curl_setopt($ch, CURLOPT_HEADER, FALSE);
				    curl_setopt($ch, CURLOPT_POST, TRUE);
				    curl_setopt($ch, CURLOPT_POSTFIELDS, $fields);
				    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    
				  	if(curl_exec($ch)){
				  		curl_close($ch);				  		
				  		$this->notification_queue_model->update_sent_status($notification->id);
				    	continue; // ?? - go to the next loop
				  	}
				}

			}catch(Exception $ex){

			}
		}
	}

	public function get_users_notifications(){
		$this->load->model('notification_queue_model');
		$typeOfError = 0;
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
			
		    $notifications = $this->notification_queue_model->get_users_notifications($userId);
			$response = array(
		    	'message' => 'success',		    	
		    	'notification' => $notifications
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'error_code' => $typeOfError,
				'successful'=> false);
		}
		echo json_encode_helper($response);	
	}

	public function enable(){
		$response = array();
		try{
			$deviceId = $this->security->xss_clean(strip_tags($this->input->post('deviceId')));			

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


			$this->notification_model->enable_device($deviceId, $userId);

			$response = array(
		    	'message' => 'Thanks for registering your device!'
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}


	public function disable(){
		try{
			$deviceId = $this->security->xss_clean(strip_tags($this->input->post('deviceId')));
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

			$userId = $this->user_session_model->getUserId($sessionToken);
			if($userId == -1){
				$typeOfError = -2;
				throw new Exception("Session is invalid.");	
			}

			$this->notification_model->enable_device($deviceId, $userId);

			$response = array(
		    	'message' => 'You have successfull unregistered your device.'
		    );
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}
		$this->output->set_output(json_encode_helper($response));
	}

}

?>