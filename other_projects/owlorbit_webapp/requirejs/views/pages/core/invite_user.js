/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
define(['app', 'jquery'], function(App, $) {
	require(['select2'], function() {
		var users = [];

		function isValidEmail(val){
			var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    		return pattern.test(val);
		}

		function initInviteUserInput(){
			$("#invite-users-card").select2({
				multiple: false,				
				createSearchChoice: function(term, data){
					if($(data).filter(
						function(){
							return true;
						}
					).length===0){
						if(isValidEmail(term)){
							return {id: term, text:term};	
						}						
					}
				},
				data: function() { return {results: users}; }
			});

			$("#invite-users-card").change(function(){
				$("#inviteUserMsgContainer").fadeOut();
			});

			$("#inviteUserBtn").click(function(){
				$("#inviteUserMsgContainer").hide();
			});

			$("#invite-users-container .select2-input").keyup(function(evt){

				var userSearch = $(this).val();
				if(userSearch == ""){
					return;
				}

				var dataToBeSent = "name=" + userSearch + "&includeLoggedInUser=0";
				$.ajax({
				    type: "POST",
				    url: "/user/get",
				    data: dataToBeSent,				    
				    dataType: "json",
				    success: function(data){
						if(data.successful){
							users = $.map(data.users, function (value, index){
								//for organizations, i want the full view of first + last name...
								//var displayText = value.firstName + " " + value.lastName + " (" + value.name + ")";
								var displayText = value.name;
								return {id: value.id, text: displayText};
							});
						}else{
							queryListOfUsers = null;
							$("#user-available").html(data.message);							
						}
				    },
				    failure: function(errMsg) {
				        alert(errMsg);
				    }
				});					
							
	    	});
		}


		function submitHandler(){
			
			$("#invite-user-btn").click(function(){
				var invite = $("#invite-users-card").val();
				var dataToBeSent = {invite: invite, boardId: board.id};
				$("#inviteUserErrorContainer").hide();

				$.ajax({
				    type: "POST",
				    url: "/board/invite",
				    data: dataToBeSent,
				    dataType: "json",
				    cache: false,
				    success: function(data){
				    	$("#inviteUserMsgContainer").hide();
				    	if(data.successful){
				    		$("#inviteUserMsgContainer").css("color", "green")
				    	}else{
				    		$("#inviteUserMsgContainer").css("color", "red")
				    	}

						$("#inviteUserMsgContainer").fadeIn();
				    	$("#inviteUserMsg").html(data.message);				    	
				    }
				});
			})
			
		}


		function init(){
			initInviteUserInput();
			submitHandler();
		}

		init();
	});
});