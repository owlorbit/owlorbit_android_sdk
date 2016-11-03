/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
define(['app','jquery'], function(App, $) {
	require(['bootstrap', 'metismenu'], function(){
		require(['morris', 'sbadmin', 'spin', 'ladda'], function(m, s, spin, Ladda){		

			var dataToBeSent;
			$("#name").keyup(function(event) {
				dataToBeSent = $("#name").serialize();
				if($("#name").val() == ""){				
					$("#usernameMsg").html("");
					return;
				}

				$.ajax({
				    type: "POST",
				    url: "/create/user_exists",
				    data: dataToBeSent,				    
				    dataType: "json",
				    success: function(data){
						$("#usernameMsg").html(data.message);
						$("#usernameMsg").css('color', data.color);
				    },
				    failure: function(errMsg) {
				        alert(errMsg);
				    }
				});
			});			

	    	$("#create").click(function(event){
	    		event.preventDefault();
				var dataToBeSent = $("#create-account").serialize();
				var l = Ladda.create(this);
				l.start();
				setTimeout(function(){
				$.ajax({
				    type: "POST",
				    url: "/create/submit",
				    data: dataToBeSent,				    
				    dataType: "json",
				    success: function(data){
				    	if(data.successful){
							location.reload();						
						}else{
							l.stop();
							$("#errorMsg").hide();
							$("#errorMsg").fadeIn();
							$("#errorMsg").css('color', "red");
							$("#errorMsg").html(data.message);							
						}
				    },
				    failure: function(errMsg) {
				        alert(errMsg);
				    }
				  });}, 500);
			});


		});
	});
});