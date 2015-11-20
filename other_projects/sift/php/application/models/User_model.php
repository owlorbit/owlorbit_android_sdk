<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class User_model extends CI_Model {

    var $id   = '';
    var $username   = '';
    var $password = '';
    var $first_name    = '';
    var $phone_number    = '';
    var $last_name    = '';
    var $email    = '';
    var $account_type    = 'standard';

    function __construct(){        
        parent::__construct();
        $this->load->database();
    }
  
    function get_last_ten_entries(){
        $query = $this->db->get('users', 10);
        return $query->result();
    }

    function test(){
        return "test";
    }

    //post entry
    function insert_entry(){
        //$this->username    = $this->security->xss_clean(strip_tags($_POST['username']));
        $this->email       = $this->security->xss_clean(strip_tags($_POST['email']));    
        if($this->emailExists($this->email)){
            throw new Exception("Please use another email address!");
        }

        $this->password    = $this->security->xss_clean(strip_tags($_POST['password']));
        $this->first_name  = $this->security->xss_clean(strip_tags($_POST['first_name']));
        $this->last_name   = $this->security->xss_clean(strip_tags($_POST['last_name']));
        $this->phone_number   = $this->security->xss_clean(strip_tags($_POST['phone_number']));
        $this->password = sha1(sha1($this->password.$this->config->item("salt")));

        unset($this->id);
        $this->db->insert('users', $this);   
    }

    function emailExists($email){
        $query = "select * from users where email = ?;";
        $result = $this->db->query($query, array($email));
        if($result->num_rows() > 0){
            return true;
        }
        return false;
    }    


    function update_entry(){
        $this->title   = $_POST['title'];
        $this->content = $_POST['content'];

        unset($this->id);
        $this->db->update('entries', $this, array('id' => $_POST['id']));
    }

}

?>