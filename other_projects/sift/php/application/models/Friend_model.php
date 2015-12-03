<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Friend_model extends CI_Model {

    //pending, accepted, declined
    var $id   = '';
    var $user_id   = '';
    var $friend_user_id = '';
    var $status    = '';

    function __construct(){        
        parent::__construct();
        $this->load->database();
    }
  
    function test(){
        return "test";
    }

    function get($where){
        $this->db->where($where);
        return $this->db->get('friends');
    }

    function all($userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;

        $query = "select id, first_name, last_name, 
            email, phone_number, account_type, avatar_original from friends f
        inner join users u
            on u.id = f.friend_user_id
        where user_id = ? and status = 'accepted'
            union
        select id, first_name, last_name, 
            email, phone_number, account_type, avatar_original from friends f
        inner join users u
            on u.id = f.user_id
        where (friend_user_id = ?)  and status = 'accepted'
            limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($userId, $userId));

        error_log($this->db->last_query());

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    } 

    function pending_friends_you_sent($userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;

        $query = "select id, first_name, last_name, 
            email, phone_number, account_type, avatar_original from friends f
        inner join users u
            on u.id = f.friend_user_id
        where user_id = ? and status = 'pending'
            limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($userId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }

    function pending_friends_they_sent($userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;
        $query = "select id, first_name, last_name,
            email, phone_number, account_type, avatar_original from friends f
        inner join users u
            on u.id = f.user_id
        where friend_user_id = ? and status = 'pending'
            limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($userId));
        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }    

    function insert($data){

        if($this->exists($data['friend_user_id'], $data['user_id'])){
            //this means the other user sent an accept...
            $this->accept($userId, $friendUserId);
            return "You are friends now!";
        }

        if(!$this->exists($data['user_id'], $data['friend_user_id'])){
            $this->db->insert('friends', $data);
            return "Friend request sent.";
        }else{
            throw new Exception("Friend request already sent");
        }
    }

    function accept($userId, $friendUserId){
        $query = "update friends set status='accepted' where user_id = ? and friend_user_id = ?;";
        $this->db->query($query, array($userId, $friendUserId));
    }

    function decline($userId, $friendUserId){
        $query = "update friends set status='declined' where user_id = ? and friend_user_id = ?;";
        $this->db->query($query, array($userId, $friendUserId));
    }    

    function exists($userId, $friendUserId){
        $query = "select * from friends where user_id = ? and friend_user_id = ?;";
        $result = $this->db->query($query, array($userId, $friendUserId));

        if($result->num_rows() > 0){
            return true;
        }
        return false;
    }
}

?>