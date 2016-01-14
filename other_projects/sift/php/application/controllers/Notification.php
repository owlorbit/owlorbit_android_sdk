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
	}

	public function index(){

		$this->load->library('parse-php-sdk/src/Parse/ParseClient');		
		
		$this->load->library('parse-php-sdk/src/Parse/ParseObject');		
		$this->load->library('parse-php-sdk/src/Parse/ParsePush');	

		$this->load->library('parse-php-sdk/src/Parse/ParseInstallation');	
		$this->load->library('parse-php-sdk/src/Parse/ParseQuery');	

		//$this->parseclient->initialize( "mmuRcbOhsjLPCFPv81ZO8HWVhn1YcIb8F93e05ZN", "fURuXJR5xjG7p2B7AqdKANUJVwb9pko4y4n3zi7o", "eyGXoKU8PTTeXYXJdSY9BonQu3gZEv9sv7x1Yrcu" );				
		ParseClient::initialize('mmuRcbOhsjLPCFPv81ZO8HWVhn1YcIb8F93e05ZN', 'zMVFPm0zShj7pxFjlpGGhOoi0BwYtZzmKXNQVqAP', 'eyGXoKU8PTTeXYXJdSY9BonQu3gZEv9sv7x1Yrcu');
		// Push to Channels

		$data = array("alert" => "FUCK SHIT");
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

	public function add_device(){
		try{

		}catch(Exception $ex){

		}
	}

}

?>