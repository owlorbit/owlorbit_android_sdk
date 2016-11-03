<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Notification_queue_model extends CI_Model {


	function __construct(){
        parent::__construct();
        $this->load->database();
    }

    //check the existing registered devices..
    //then submit to Parse the message.
    //message should contain..
    //roomname, sender name, message


    function add($roomId, $messageId, $senderUserId, $type){

        $this->load->model('room_model');
        $this->load->model('notification_model');
        $users = $this->room_model->get_users($roomId);

        foreach ( $users as $user){
            if($user->user_id == $senderUserId){
                continue;
            }

            $devices = $this->notification_model->get_devices_by_user_id($user->user_id);
            foreach($devices as $device){
                $query = "insert into notification_queue (user_id, message_id, room_id, device_id, type) values (?, ?, ?, ?, ?)";
                $this->db->query($query, array($senderUserId, $messageId, $roomId, $device->device_id, $type));
            }      
        }
    }

    function add_no_room($messageId, $senderUserId, $receiverUserId, $type){
        $this->load->model('room_model');
        $this->load->model('notification_model');

        $devices = $this->notification_model->get_devices_by_user_id($receiverUserId);
        foreach($devices as $device){
            $query = "insert into notification_queue (user_id, message_id, device_id, type) values (?, ?, ?, ?)";
            $this->db->query($query, array($senderUserId, $messageId, $device->device_id, $type));
        }        
    }

    function update_sent_status($id){
        $query = "update notification_queue set sent_to_parse = 1 where id = ?";        
        $result = $this->db->query($query, array($id));
    }

    function get_users_notifications($userId){
        $query = "select * from (select m.id as message_id, u.avatar_original, r.id as room_id, m.created as message_created, u.id as user_id, u.first_name, u.last_name, message, message_type, if(r.name IS NULL, '', r.name) as room_name, ru.accepted,
                    u2.avatar_original as other_avatar_original, 
                    u2.first_name as other_first_name, 
                    u2.last_name as other_last_name
                    from messages m
                        inner join users u
                            on u.id = m.user_id
                        left join users u2
                            on u2.id = m.other_user_id
                        left join rooms r
                            on r.id = m.room_id
                        left join room_users ru
                            on (ru.room_id = r.id and ru.user_id = u.id)
                        where m.active = 1 and (r.id in (select room_id from room_users where user_id = ?) or (r.id is null and m.user_id = ?))
                        and m.message_type <> 'text'
                        order by m.id desc) as t1                   
                        where (case 
                        when user_id = ? then
                            message_type <> 'meetup'
                        else 
                            TRUE
                        end) and (case 
                        when user_id = ? then
                            message_type <> 'new_room'
                        else 
                            TRUE
                        end);";

        $result = $this->db->query($query, array($userId, $userId, $userId, $userId));

        if($result->num_rows() > 0){
            return $result->result();
        }

        return array();
    }

    function get_not_sent(){
        $query = "select nq.id, m.id as message_id, r.id as room_id, m.created as message_created, u.id as user_id, first_name, last_name, message, message_type, if(r.name IS NULL, '', r.name) as room_name, device_id, ru.accepted
                    from notification_queue  nq
                        inner join users u
                            on u.id = nq.user_id
                        inner join messages m
                            on m.id = nq.message_id
                        inner join rooms r
                            on r.id = m.room_id
                        inner join room_users ru
                            on (ru.room_id = r.id and ru.user_id = u.id)
                    where sent_to_parse = 0 and m.active = 1 and ru.accepted = 1;";
        $result = $this->db->query($query)->result();
        return $result;
    }

    function get_not_sent_no_room(){
        $query = "select nq.id, m.id as message_id, m.created as message_created, u.id as user_id, first_name, last_name, message, message_type, device_id
                    from notification_queue  nq
                        inner join users u
                            on u.id = nq.user_id
                        inner join messages m
                            on m.id = nq.message_id                        
                    where sent_to_parse = 0  and nq.room_id is null and m.active = 1;";
        $result = $this->db->query($query)->result();
        return $result;
    }    
}

?>