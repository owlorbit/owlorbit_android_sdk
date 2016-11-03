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
    function insert_entry($betaCode){

        if($this->isPromoRequired()){       
            $this->load->model('beta_model');     
            $doesBetaCodeExist = $this->beta_model->does_beta_code_exist($betaCode);
            if($doesBetaCodeExist){
                $betaCodeObj = $this->beta_model->get_by_betacode($betaCode);
                if($betaCodeObj->invite_count > 0){
                    $this->beta_model->updateBetaCodeCount($betaCode);
                }else{
                    throw new Exception("Invite has expired!");    
                }
            }else{
                throw new Exception("Invite is invalid!");
            }
        }

    
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

    function isPromoRequired(){
        $query = "select * from server_info";
        $result = $this->db->query($query);
        if($result->num_rows() > 0){
            $betaInvite = $result->result()[0]->enable_only_beta_invite;

            if($betaInvite){
                return true;
            }
        }
        return false;        
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
        and id !=  ? and deleted = 0

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

    function find_friends_not_in_room($value, $userId, $pageIndex, $roomId){
        $ITEMS_PER_PAGE = 25;
        $valueLike = '%'.$value.'%';
        $query = "select id, first_name, last_name, email, phone_number, account_type, avatar_original from friends f

            left join room_users ru
                on (ru.user_id = f.user_id or
                    ru.user_id = f.friend_user_id)

            left join users u
                on u.id = ru.user_id

            where
            ((email like ? or first_name like ? or last_name like ?) 
               or (phone_number = ?) or (CONCAT_WS(' ', first_name, last_name) like ?) 
             or (CONCAT_WS(', ', last_name, first_name) like ?) )
             and
            (f.user_id  in (select user_id as id from friends where friend_user_id = ? and status = 'accepted')
            or f.friend_user_id in (select friend_user_id as id from friends where user_id = ? and status = 'accepted'))

            and id !=  ?   
                and 

            (case 
            when room_id = ? then
                (ru.active = 0 and ru.accepted = 1)
            else 
                ru.user_id not in (
                    select user_id from room_users where room_id = ?
                )    
                or room_id is null
            end)
            group by id
        limit ".$ITEMS_PER_PAGE." offset ".(($pageIndex-1) * $ITEMS_PER_PAGE).";";

        $result = $this->db->query($query, array($valueLike, $valueLike, $valueLike, $value, $valueLike, $valueLike, $userId,
            $userId, $userId, $roomId, $roomId));

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


    function get_by_id($id){
        $query = "select * from users where id = ?";
        $result = $this->db->query($query, array($id));
        if($result->num_rows() > 0){
            return $result->row(0);
        }else{      
            return null;
        }       
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