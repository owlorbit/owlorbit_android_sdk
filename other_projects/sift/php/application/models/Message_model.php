<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Message_model extends CI_Model {

    var $id   = '';
    var $user_id   = '';
    var $device_id   = '';
    var $longitude = '';
    var $latitude = '';

    function __construct(){
        parent::__construct();
        $this->load->database();
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

    function initiate_room($creatorUserId, $userIds){

        //TODO make fucking sure userIds only are numbers
        $userCount = count($userIds); //$userIds        
        $userIdString = "";
        foreach ( $userIds as $userId){ 
            $userIdString .= $userId.',';
        }
        $userIdString = rtrim($userIdString, ",");
        $query = "select count(room_id) as room_count, room_id from room_users 
            where room_id in (select id from rooms where user_id in (".$userIdString.")) 
        group by room_id having room_count = ?;";
        $result = $this->db->query($query, array($userCount));
        
        error_log($this->db->last_query());
        if($result->num_rows() > 0){            
            return $result->row(0)->room_id;            
        }
        //create the room..
        $query = "insert into rooms (user_id) values (?)";
        $result = $this->db->query($query, array($creatorUserId));
        $newRoomId = $this->db->insert_id();
        error_log('new room id: '. $newRoomId);

        foreach ( $userIds as $userId){ 
            $query = "insert into room_users (user_id, room_id) values (?, ?)";
            $result = $this->db->query($query, array($userId, $newRoomId));
        }

        return $newRoomId;
    }
    //post entry
    function insert_entry($userId){
        /*
        $this->user_id   = $userId;
        $this->device_id   = $this->security->xss_clean(strip_tags($_POST['device_id']));
        $this->longitude    = $this->security->xss_clean(strip_tags($_POST['longitude']));
        $this->latitude  = $this->security->xss_clean(strip_tags($_POST['latitude']));*/

        unset($this->id);
        $this->db->insert('message', $this);
    }
    

}

?>