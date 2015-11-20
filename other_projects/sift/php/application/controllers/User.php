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
		$this->load->model('user_model');
	}

	public function index(){

		$response = array(
		    'message' => 'User added!'
		);

		$this->output->set_output(json_encode_helper($response));		
	}

	public function add(){		
		$response = array();
		try{
		    if($this->add_validate()){
		    	$this->user_model->insert_entry();
		    }
			$response = array(
		    	'message' => 'User added!'
		    );		    
		}catch(Exception $e){
			$response = array('message'=>$e->getMessage(),
				'successful'=> false);
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
