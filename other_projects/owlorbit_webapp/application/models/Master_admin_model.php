<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Master_admin_model extends CI_Model {

	function __construct(){
        parent::__construct();
        $this->load->database();
    }

    //check the existing registered devices..
    //then submit to Parse the message.
    //message should contain..
    //roomname, sender name, message

    function get_all_users(){
        $query = "select * from users;";

        $result = $this->db->query($query);

        if($result->num_rows() > 0){
            return $result->result();
        }

        return array();
    }

    function get_all_locations(){
        $query = "select * from users u
            inner join locations l
                on l.user_id = u.id;";

        $result = $this->db->query($query);
        if($result->num_rows() > 0){
            return $result->result();
        }

        return array();
    }

    function get_all_users_no_pictures(){
        $query = "select * from users where avatar_original = '';";

        $result = $this->db->query($query);
        if($result->num_rows() > 0){
            return $result->result();
        }

        return array();
    }
  
}

?>