<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Master extends CI_Controller {

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
		$this->load->model('user_model');
		$this->load->model('user_token_model');
		$this->load->model('user_session_model');
		$this->load->model('master_admin_model');
		$this->load->library('verify_session');
	}

	public function users(){
		$userId = $this->session->userdata("userId");		
		$data['users'] = $this->master_admin_model->get_all_users();
		//
		if($userId == 91 || $userId == 94 || $userId == 101){							
			$this->load->view('master/index', $data);			
		}else{
			$data['requirejs'] = '/requirejs/views/pages/core/login.js';
			$this->load->view('template/header');
			$this->load->view('welcome/index');
			$this->load->view('template/footer', $data);
		}
	}

	public function map(){
		$userId = $this->session->userdata("userId");		
		$data['users'] = $this->master_admin_model->get_all_locations();
		//
		if($userId == 91 || $userId == 94  || $userId == 101){							
			$this->load->view('master/map', $data);
		}else{
			$data['requirejs'] = '/requirejs/views/pages/core/login.js';
			$this->load->view('template/header');
			$this->load->view('welcome/index');
			$this->load->view('template/footer', $data);
		}
	}

	public function users_no_picture(){
		$userId = $this->session->userdata("userId");		
		$data['users'] = $this->master_admin_model->get_all_users_no_pictures();
		//
		if($userId == 91 || $userId == 94 || $userId == 101){							
			$this->load->view('master/index', $data);			
		}else{
			$data['requirejs'] = '/requirejs/views/pages/core/login.js';
			$this->load->view('template/header');
			$this->load->view('welcome/index');
			$this->load->view('template/footer', $data);
		}
	}
}
