<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Location_model extends CI_Model {



    function __construct(){        
        parent::__construct();
        $this->load->database();
    }
  
    function get_last_ten_entries(){
        $query = $this->db->get('users', 10);
        return $query->result();
    }

    function get_all_locations_in_room($userId, $roomId){

        /*$query = "select * from locations where id in (select * from locations where user_id in (select user_id from room_users where user_id != ?
                    and room_id = ?
                    and active = 1 and is_hidden = 0) group by user_id);";*/

        $query = "select * from locations where user_id in (select user_id from room_users where user_id != ?
                    and room_id = ?
                    and active = 1 and is_hidden = 0 and accepted = 1) group by user_id;";

        $result = $this->db->query($query, array($userId, $roomId));
        if($result->num_rows() > 0){
            return $result->result();
        }

        return array();
    }

    function get_all_standard_locations_in_room($userId, $roomId){

/*
        $query = "select * from locations where id in (select max(id) from locations where user_id in (select user_id from room_users where user_id != ?
                    and room_id = ?
                    and active = 1 and is_hidden = 0) group by user_id);";*/

        $query = "select * from locations where user_id in (select user_id from room_users where user_id != ?
                    and room_id = ?
                    and active = 1 and is_hidden = 0 and accepted = 1) group by user_id;";

        $result = $this->db->query($query, array($userId, $roomId));
        if($result->num_rows() > 0){            
            return $result->result();
        }

        return array();
    }    

    function get(){
        $this->id = $this->security->xss_clean(strip_tags($_GET['id']));
        $query = "select * from users where id = ? and deleted = 0;";
        return $this->db->query($query, array($this->id));
    }

    //post entry
    function insert_entry($userId){

        //if userId exists, then just update...
        $device_id   = $this->security->xss_clean(strip_tags($_POST['device_id']));
        $longitude    = $this->security->xss_clean(strip_tags($_POST['longitude']));
        $latitude  = $this->security->xss_clean(strip_tags($_POST['latitude']));

        $query = "select * from locations where user_id = ?";
        $result = $this->db->query($query, array($userId));
        if($result->num_rows() > 0){            
            //update
            $updateQuery = "update locations set longitude = ?, latitude = ?, created = CURRENT_TIMESTAMP, device_id = ? where user_id = ?";   
            $this->db->query($updateQuery, array($longitude, $latitude, $device_id, $userId));
        }else{
            //insert..
            $insertQuery = "insert into locations (user_id, longitude, latitude, device_id) values (?, ?, ?, ?);";
            $this->db->query($insertQuery, array($userId, $longitude, $latitude, $device_id));

        }

    }
    

}

?>