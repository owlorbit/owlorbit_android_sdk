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

    function get_by_room($roomId, $pageIndex){
        $ITEMS_PER_PAGE = 25;

        $query = "select m.id, u.first_name, u.last_name, u.id as user_id, m.created, message, u.avatar_original, m.room_id from messages m
            inner join users u
                on u.id = m.user_id
            where m.room_id = ? and m.active = 1
                order by m.created desc
            limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";            

        $result = $this->db->query($query, array($roomId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }

    function recent_messages($userId, $pageIndex){
        $ITEMS_PER_PAGE = 25;
        $query = "SELECT m.id, m.room_id, u.id as user_id, first_name,last_name, r.name as room_name, 
                  avatar_original, message, m.created FROM messages m
            inner join users u
                on u.id = m.user_id
            inner join rooms r
                on r.id = m.room_id
            where 
                m.created in (select max(created) from messages GROUP BY room_id) and r.active = 1
            and m.room_id in (select room_id from room_users where user_id = ? group by room_id)
                order by m.created desc
            limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";            

        $result = $this->db->query($query, array($userId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }

    function recent_messages_in_room($userId, $roomId){
        $ITEMS_PER_PAGE = 25;
        $query = "SELECT m.id, m.room_id, u.id as user_id, first_name,last_name, r.name as room_name, 
                  avatar_original, message, m.created FROM messages m
            inner join users u
                on u.id = m.user_id
            inner join rooms r
                on r.id = m.room_id
            where 
                m.created in (select max(created) from messages GROUP BY room_id) and r.active = 1
            and m.room_id in (select room_id from room_users where user_id = ? and room_id = ? group by room_id)
                order by m.created desc;";            

        $result = $this->db->query($query, array($userId, $roomId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
    }    

    function recent_message_attributes($userId){
        $query = "select user_id, room_id, avatar_original, first_name from room_users ru
                inner join users u
            on u.id = ru.user_id
                where user_id != ? and room_id in (select distinct(room_id) from room_users where user_id = ?);";

        $result = $this->db->query($query, array($userId, $userId));

        if($result->num_rows() > 0){            
            return $result->result();
        }
        return array();
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
            where room_id in (select room_id from room_users where user_id in (".$userIdString."))
            and user_id in (".$userIdString.")
        group by room_id having room_count = ?;";
        $result = $this->db->query($query, array($userCount));
        error_log($this->db->last_query());

        if($result->num_rows() > 0){            
            return $result->row(0)->room_id;
        }

        $query = "insert into rooms (user_id) values (?)";
        $result = $this->db->query($query, array($creatorUserId));
        $newRoomId = $this->db->insert_id();
        error_log('new room id: '. $newRoomId);
        
        foreach ( $userIds as $userId){ 
            error_log('user id>>: '.$userId);

            $query = "insert into room_users (user_id, room_id) values (?, ?)";
            $result = $this->db->query($query, array($userId, $newRoomId));
            error_log('insert room_id: '.$this->db->last_query());
        }

        return $newRoomId;
    }
    //post entry
    function insert($data){
        $this->db->insert('messages', $data);
        return $this->db->insert_id();
    }
    

}

?>