<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Notification_model extends CI_Model {


	function __construct(){
        parent::__construct();
        $this->load->database();
    }


    function get_devices_by_user_id($userId){
    	$query = "select device_id from parse_devices where user_id = ? and active = 1;";
    	$result = $this->db->query($query, array($userId));

    	if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }

    function enable_device($deviceId, $userId){
    	//check for count

    	if($this->doesExist($deviceId, $userId)){
    		$query = "update parse_devices set active = 1 where device_id = ? and user_id = ?";
    	}else{
    		$query = "insert into parse_devices (device_id, user_id) values (?, ?)";
    	}

    	$result = $this->db->query($query, array($deviceId, $userId));
    }

    function doesExist($deviceId, $userId){
		$query = "select * from parse_devices where device_id = ? and user_id = ?";
        $result = $this->db->query($query, array($deviceId, $userId));
        if($result->num_rows() > 0){            
            return true;
        }
        return false;
    }

    function disable_device($deviceId, $userId){

		if($this->doesExist($deviceId, $userId)){
    		$query = "update parse_devices set active = 0 where device_id = ? and user_id = ?";
    	}else{
    		$query = "insert into parse_devices (device_id, user_id, active) values (?, ?, 0)";
    	}

    	$result = $this->db->query($query, array($deviceId, $userId));
    }
}

?>