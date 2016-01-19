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


    function add($roomId, $messageId, $senderUserId){

        $this->load->model('room_model');
        $this->load->model('notification_model');
        $users = $this->room_model->get_users($roomId);

        foreach ( $users as $user){
            if($user->user_id == $senderUserId){
                continue;
            }

            $devices = $this->notification_model->get_devices_by_user_id($user->user_id);
            foreach($devices as $device){
                $query = "insert into notification_queue (user_id, message_id, room_id, device_id) values (?, ?, ?, ?)";
                $this->db->query($query, array($senderUserId, $messageId, $roomId, $device->device_id));
            }      
        }
    }

    function update_sent_status($id){
        $query = "update notification_queue set sent_to_parse = 1 where id = ?";        
        $result = $this->db->query($query, array($id));
    }

    function get_not_sent(){
        $query = "select nq.id, m.id as message_id, first_name, last_name, message, message_type, if(r.name IS NULL, '', r.name) as room_name, device_id
                    from notification_queue  nq
                        inner join users u
                            on u.id = nq.user_id
                        inner join messages m
                            on m.id = nq.message_id
                        inner join rooms r
                            on r.id = m.room_id
                    where sent_to_parse = 0 and m.active = 1;";
        $result = $this->db->query($query)->result();
        return $result;
    }    
}

?>