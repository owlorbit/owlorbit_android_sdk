<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Meetup_model extends CI_Model {

    var $id   = '';
    var $user_id   = '';
    var $title   = '';
    var $subtitle   = '';
    var $room_id   = '';
    var $is_global   = '';
    var $longitude = '';
    var $latitude = '';

    function __construct(){        
        parent::__construct();
        $this->load->database();
    }
  
    function get_last_ten_entries(){
        $query = $this->db->get('meetup', 10);
        return $query->result();
    }

    function get_all_in_room($roomId){

        $query = "select distinct(id), user_id, room_id, title, longitude, latitude, created, active, subtitle, display_before, is_global from (select *
                    from meetup where user_id in (select user_id from room_users where room_id = ?) and active = 1 and room_id = ? union all
                select * from meetup where user_id in (select user_id from room_users where room_id = ?) and active = 1 and is_global = 1) y;";
        $result = $this->db->query($query, array($roomId, $roomId, $roomId));
        if($result->num_rows() > 0){            
            return $result->result();
        }

        return array();
    }

    function get(){
        $this->id = $this->security->xss_clean(strip_tags($_GET['id']));
        $query = "select * from users where id = ? and deleted = 0;";
        return $this->db->query($query, array($this->id));
    }

    function update($meetupId, $userId, $longitude, $latitude){
        //check if the meetup id's creator is the userId being passed.

        $query = "select user_id from meetup where id = ? and user_id = ?";
        $result = $this->db->query($query, array($meetupId, $userId));

        if($result->num_rows() == 0){
            return;
        }

        $updateQuery = "update meetup set longitude = ?, latitude = ? where id = ?";
        $this->db->query($updateQuery, array($longitude, $latitude, $meetupId));
    }

    function disable($meetupId, $userId){
        //check if the meetup id's creator is the userId being passed.

        $query = "select user_id from meetup where id = ? and user_id = ?";
        $result = $this->db->query($query, array($meetupId, $userId));
        if($result->num_rows() == 0){
            return;
        }

        $updateQuery = "update meetup set active = 0 where id = ?";
        $this->db->query($updateQuery, array($meetupId));
    }    

    //post entry
    function insert_entry($userId){
        $this->user_id   = $userId;
        $this->title   = $this->security->xss_clean(strip_tags($_POST['title']));

        $this->subtitle   = $this->security->xss_clean(strip_tags($_POST['subtitle']));
        $this->room_id   = $this->security->xss_clean(strip_tags($_POST['roomId']));
        $this->is_global   = $this->security->xss_clean(strip_tags($_POST['isGlobal']));

        $this->longitude    = $this->security->xss_clean(strip_tags($_POST['longitude']));
        $this->latitude  = $this->security->xss_clean(strip_tags($_POST['latitude']));

        $query = "insert into meetup (user_id,  title, subtitle, room_id, is_global, longitude, latitude ) values (?, ?, ?, ?, ?, ?, ?)";
        $result = $this->db->query($query, array($this->user_id, $this->title, $this->subtitle, $this->room_id,
            $this->is_global, $this->longitude, $this->latitude));

        error_log($this->db->last_query());
    }
    

}

?>