<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Beta_model extends CI_Model {

    function __construct(){        
        parent::__construct();
        $this->load->database();
    }

    function get_beta_invite($userId){
        $stringLength = 7;

        $query = "select * from beta_invites where user_id = ?";
        $result = $this->db->query($query, array($userId));
        if($result->num_rows() > 0){            
            return $result->result()[0];
        }else{
            $betaCode = $this->generateRandomString($stringLength);        
            while($this->does_beta_code_exist($betaCode)){
                $betaCode = $this->generateRandomString($stringLength);
            }

            $insertQuery = "insert into beta_invites (user_id, code) values (?, ?);";
            $this->db->query($insertQuery, array($userId, $betaCode));            

            return $this->get_by_betacode($betaCode);
        }
    }

    function get_by_betacode($betaCode){
        $query = "select * from beta_invites where code = ?";
        $result = $this->db->query($query, array($betaCode));
        if($result->num_rows() > 0){
            return $result->result()[0];
        }else{
            return null;
        }
    }

    function does_beta_code_exist($betaCode){
        $query = "select * from beta_invites where code = ?";
        $result = $this->db->query($query, array($betaCode));
        if($result->num_rows() > 0){
            return true;
        }else{
            return false;
        }
    }

    function generateRandomString($length = 10) {
        $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }

    function updateBetaCodeCount($betaCode){        
        $query = "update beta_invites set invite_count = (invite_count - 1) where code = ?";
        $this->db->query($query, array($betaCode));
    }
}

?>