<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Location_model extends CI_Model {

    var $id   = '';
    var $user_id   = -1;
    var $longitude = 0.0;
    var $latitude = 0.0;


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
    function insert_entry(){
        $this->user_id   = $this->security->xss_clean(strip_tags($_POST['user_id']));
        $this->longitude    = $this->security->xss_clean(strip_tags($_POST['longitude']));
        $this->latitude  = $this->security->xss_clean(strip_tags($_POST['latitude']));

        unset($this->id);
        $this->db->insert('users', $this);
    }

    function update_entry(){
        $this->title   = $_POST['title'];
        $this->content = $_POST['content'];

        unset($this->id);
        $this->db->update('entries', $this, array('id' => $_POST['id']));
    }

}

?>