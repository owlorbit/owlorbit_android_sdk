<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Room_model extends CI_Model {

    var $id   = '';

    function __construct(){
        parent::__construct();
        $this->load->database();
    }

    function attribute($userId, $roomId){
        $query = "select user_id as id, room_id, avatar_original, first_name from room_users ru
                inner join users u
            on u.id = ru.user_id
                where user_id != ? and room_id in (select distinct(room_id) from room_users where user_id = ? and room_id = ?);";

        $result = $this->db->query($query, array($userId, $userId, $roomId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();        
    }

    function all($userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;

        $query = "select u.id as user_id, room_id, first_name, last_name, r.name as room_name, last_message_timestamp from room_users ru 
            inner join users u
                on u.id = ru.user_id
            inner join rooms r
                on r.id = ru.room_id
            where ru.room_id in (select room_id from room_users ru2 where user_id = ?) and r.active = 1
        order by room_id, last_message_timestamp desc
            limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($userId));
        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    } 

    function get_users($roomId){
        $query = "select u.id as user_id, room_id, first_name, last_name, r.name as room_name, last_message_timestamp from room_users ru 
            inner join users u
                on u.id = ru.user_id
            inner join rooms r
                on r.id = ru.room_id
            where ru.room_id in (select room_id from room_users ru2 where room_id = ?) and r.active = 1;";

        $result = $this->db->query($query, array($roomId));
        if($result->num_rows() > 0){
            return $result->result();
        }
        return array();
    }


    function get_room($userId, $roomId){
        $ITEMS_PER_PAGE = 25;

        $query = "select u.id as user_id, room_id, first_name, last_name, r.name as room_name, last_message_timestamp from room_users ru 
            inner join users u
                on u.id = ru.user_id
            inner join rooms r
                on r.id = ru.room_id
            where ru.room_id in (select room_id from room_users ru2 where user_id = ? and room_id = ?) and r.active = 1
        order by room_id, last_message_timestamp desc;";

        $result = $this->db->query($query, array($userId, $roomId));
        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }    

}

?>