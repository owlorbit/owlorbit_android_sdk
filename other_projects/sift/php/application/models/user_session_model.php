<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
class User_Session_Model extends CI_Model{

	var $TABLE = "user_sessions";

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

	function getUserId($sessionToken){
		$query = "select userId from ".$this->TABLE." where sessionToken = ? and active = 1;";
		$result = $this->db->query($query, array($sessionToken));
		if($result->num_rows() > 0){
			return $result->row(0)->userId;
		}else{		
			return -1;
		}		
	}

	function get($where){
		$where['active'] = 1;
		$this->db->where($where);

		return $this->db->get($this->TABLE);
	}


	function updateExpiredActive(){
		$query = "update user_sessions set active = 0 where expires < now();";

		return $this->db->query($query);
	}

	function delete($data){
		$this->db->delete($this->TABLE, $data);
	}
}

?>