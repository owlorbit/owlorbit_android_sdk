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

    function get($where){
        $this->db->where($where);
        return $this->db->get('users');
    }

    //post entry
    function insert_entry(){
    
        $this->email       = $this->security->xss_clean(strip_tags($_POST['email']));        
        $this->password    = $this->security->xss_clean(strip_tags($_POST['password']));
        $this->first_name  = $this->security->xss_clean(strip_tags($_POST['first_name']));
        $this->last_name   = $this->security->xss_clean(strip_tags($_POST['last_name']));
        $this->phone_number   = $this->security->xss_clean(strip_tags($_POST['phone_number']));
        $this->password = sha1(sha1($this->password.$this->config->item("salt")));

        if($this->email_exists($this->email)){
            throw new Exception("Please use another email address!");
        }

        unset($this->id);
        $this->db->insert('users', $this);   
    }

    function find($value, $pageIndex){
        $ITEMS_PER_PAGE = 25;
        $valueLike = '%'.$value.'%';
        $query = "select id, first_name, last_name, email, phone_number, account_type, avatar_original from users where (email like ? or first_name like ? or last_name like ?) 
        or (phone_number = ?) or (CONCAT_WS(' ', first_name, last_name) like ?) 
        or (CONCAT_WS(', ', last_name, first_name) like ?) 
        limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($valueLike, $valueLike, $valueLike, $value, $valueLike, $valueLike));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }     

    function find_non_friends($value, $userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;
        $valueLike = '%'.$value.'%';
        $query = "select id, first_name, last_name, email, phone_number, account_type, avatar_original from users 

        where ((email like ? or first_name like ? or last_name like ?) 
        or (phone_number = ?) or (CONCAT_WS(' ', first_name, last_name) like ?) 
        or (CONCAT_WS(', ', last_name, first_name) like ?))

            and

        !((id in (select user_id as id from friends where friend_user_id = ?)
        or id in (select friend_user_id as id from friends where user_id = ?)))
        and id !=  ?

        limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($valueLike, $valueLike, $valueLike, $value, $valueLike, $valueLike, $userId,
            $userId, $userId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }     


    function find_friends($value, $userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;
        $valueLike = '%'.$value.'%';
        $query = "select id, first_name, last_name, email, phone_number, account_type, avatar_original from users 

        where ((email like ? or first_name like ? or last_name like ?) 
        or (phone_number = ?) or (CONCAT_WS(' ', first_name, last_name) like ?) 
        or (CONCAT_WS(', ', last_name, first_name) like ?) )

            and 

        (id in (select user_id as id from friends where friend_user_id = ? and status = 'accepted')
        or id in (select friend_user_id as id from friends where user_id = ? and status = 'accepted'))
        and id !=  ?


        limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($valueLike, $valueLike, $valueLike, $value, $valueLike, $valueLike, $userId,
            $userId, $userId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }     

    function login($email, $password){
        $query = "select * from users where email = ? and password = ?";
        $password = sha1(sha1($password.$this->config->item("salt")));

        $result = $this->db->query($query, array($email, $password));

        error_log($this->db->last_query());
        if($result->num_rows() > 0){
            $user = $this->get_user($email);

            $this->session->set_userdata( array(
                    'id'=>$user->row(0)->id
                )
            );

            return true;
        }
        throw new Exception("Wrong Password!");
    }    

    function update_avatar($userId, $targetPath){
        $query = "update users set avatar_original = ? where id = ?;";
        $result = $this->db->query($query, array($targetPath, $userId));

        error_log($this->db->last_query());
    }

    function email_exists($email){
        $query = "select * from users where email = ?;";
        $result = $this->db->query($query, array($email));
        if($result->num_rows() > 0){
            return true;
        }
        return false;
    }    

    function get_user($email){
        $query = "select * from users where email = ?";
        $result = $this->db->query($query, array($email));
        return $result;
    }

    function update_entry(){
        $this->title   = $_POST['title'];
        $this->content = $_POST['content'];

        unset($this->id);
        $this->db->update('entries', $this, array('id' => $_POST['id']));
    }

}

?>