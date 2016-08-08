<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Login extends CI_Controller {

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
		$this->load->model('user_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');

		$this->load->library('verify_session');
	}

	public function index(){

		echo "hello";
	}

	public function go(){
		$response = array();
		try{

			$email = $this->security->xss_clean(strip_tags($this->input->post('email')));
			$password = $this->security->xss_clean(strip_tags($this->input->post('password')));

			
			if($this->validate()){
				$this->user_model->login($email, $password);
			}

		    $timestamp = time();
			$user = $this->user_model->get(array('email' => $email));
			if($user->num_rows() > 0){
				$user = $user->row(0);
				$userId = $user->id;
			}else{
				throw new Exception("Error retrieving user_id");
			}

			if($this->user_token_model->isPublicTokenActive($userId)){
				$userToken = $this->user_token_model->get(array('user_id' => $userId))->row(0);
				$publicKey = $userToken->public_key;
				$privateKey = $userToken->private_key;
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
		    	'message' => 'User logged in!',
		    	'publicKey' => $publicKey,
				'privateKey' => $privateKey,
				'userId' => $userId,
				'sessionToken' => $sessionToken,
				'firstName' => $user->first_name,
				'lastName' => $user->last_name,
				'avatar_original' => $user->avatar_original,
				'phoneNumber' => $user->phone_number
		    );			
		} catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
		}

		error_log('hey there: '.json_encode_helper($response));
		$this->output->set_output(json_encode_helper($response));		
	}

	private function validate(){

        $this->form_validation->set_rules('email', 'Email', 'required|trim|max_length[255]');
        $this->form_validation->set_rules('password', 'Password', 'required|trim|max_length[255]');

        if($this->form_validation->run()){
            return true;
        }
        
        throw new Exception(validation_errors());
    }	
}
