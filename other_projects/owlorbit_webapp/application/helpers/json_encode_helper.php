<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

if ( ! function_exists('json_encode_helper'))
{
    function json_encode_helper($data)
    {
    	return json_encode($data);
	}	
}