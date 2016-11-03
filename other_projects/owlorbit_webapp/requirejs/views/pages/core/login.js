/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
define(['app','jquery'], function(App, $) {
	require(['bootstrap','metismenu'], function(m) {
		require(['morris', 'sbadmin','spin', 'ladda'], function(mo,s,spin,Ladda) {
			
			$('input').keypress(function (e) {			
				if (e.which == 13) {
					e.preventDefault();
					$("#login").click();
				}
			});

		    $(function () {
		    	$("#login").click(sendData);
			});
			
			function sendData(event){
				event.preventDefault();
				var dataToBeSent = $("#login-account").serialize();
				var l = Ladda.create(this);
				l.start();
				setTimeout(function(){
					$.ajax({
					    type: "POST",
					    url: "/login/go/",
					    data: dataToBeSent,				    
					    dataType: "json",
					    success: function(data){
					    	if(data.successful){
								//location.reload();						
							}else{
								$("#errorMsg").hide();
								$("#errorMsg").html(data.message);
								$("#errorMsg").fadeIn();
								l.stop();
							}
					    },
					    failure: function(errMsg) {
					        alert(errMsg);
					    }
					});}, 500);
				return false;
			}		
		});
	});
});