/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
define(['app','jquery'], function(App, $) {
	require(['bootstrap', 'metismenu'], function(){
		require(['morris', 'sbadmin'], function(){

		    $(function () {

		    	$("#name").keypress(function(evt) {
		    		if(evt.keyCode === 13){
		    			submitForgot();
		    			return false;
		    		}
		    	});

		    	$("#submit").click(function(event){
					submitForgot();
				});

		    	function submitForgot(){
					var dataToBeSent = $("#forgot-account").serialize();
					
					$.ajax({
					    type: "POST",
					    url: "/forgot/submit",				    
					    data: dataToBeSent,				    
					    dataType: "json",
					    success: function(data){					    	
					    	if(data.successful){
					    		$("#errorMsg").hide();
								$("#errorMsg").fadeIn();
								$("#errorMsg").css('color', "green");
								$("#errorMsg").html(data.message);
							}else{
								$("#errorMsg").hide();
								$("#errorMsg").fadeIn();
								$("#errorMsg").css('color', "red");
								$("#errorMsg").html(data.message);
							}
					    },
					    failure: function(errMsg) {
					        alert(errMsg);
					    }
					  });
		    	}


			});


		});
	});
});