<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Location_model extends CI_Model {

    var $id   = '';
    var $user_id   = '';
    var $device_id   = '';
    var $longitude = '';
    var $latitude = '';


    function __construct(){        
        parent::__construct();
        $this->load->database();
    }
  
    function get_last_ten_entries(){
        $query = $this->db->get('users', 10);
        return $query->result();
    }

    function get_all_locations_in_room($userId, $roomId){
        $query = "select user_id, longitude, latitude, device_id, created from locations l where
            l.created in  (select max(created) from locations GROUP BY user_id)
                and user_id != ?
                and user_id in (select user_id from room_users where room_id = ?);";

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
        $this->user_id   = $userId;
        $this->device_id   = $this->security->xss_clean(strip_tags($_POST['device_id']));
        $this->longitude    = $this->security->xss_clean(strip_tags($_POST['longitude']));
        $this->latitude  = $this->security->xss_clean(strip_tags($_POST['latitude']));

        unset($this->id);
        $this->db->insert('locations', $this);
    }
    

}

?>