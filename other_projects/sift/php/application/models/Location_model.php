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