<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
class User_Token_Model extends CI_Model{

	var $TABLE = "user_tokens";

	function __construct(){	
		$this->load->database();
		parent::__construct();
	}

	function insert($data){
		$this->db->insert($this->TABLE, $data);
	}

	function update($data, $where){
		if($where != null){
			$this->db->where($where);
		}
		$this->db->update($this->TABLE, $data);
	}

	function get($where){
		$where['active'] = 1;
		$this->db->where($where);

		return $this->db->get($this->TABLE);
	}

	function updateExpiredActive(){
		$query = "update user_tokens set active = 1 where expires < now();";

		return $this->db->query($query);
	}

	function delete($data){
		$this->db->delete($this->TABLE, $data);
	}	

	function isPublicTokenActive($userId){
		$query = "select * from user_tokens where userId = ? and active = 1;";
		$result = $this->db->query($query, array($userId));

		if($result->num_rows() > 0){
			return true;
		}
		return false;
	}


}

?>