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
				$("#repassword").keypress(function(evt) {		    		

		    		if(evt.keyCode === 13){
		    			submitReset();		    			
		    			return false;
		    		}		    		
		    	});		    	

		    	$("#submit").click(function(event){
					submitReset();
				});



		    	function submitReset(){
					var dataToBeSent = $("#forgot-account").serialize();
						
					if($("#repassword") == ""){
						return;
					}

					$.ajax({
					    type: "POST",
					    url: "/forgot/handle_code_submit",
					    data: dataToBeSent,
					    dataType: "json",
					    success: function(data){					    	
					    	if(data.successful){
					    		$("#msg").hide();
								$("#msg").fadeIn();
								$("#msg").css('color', "green");
								$("#msg").html(data.message);
						
								setTimeout(function(){
                         			location.reload();
                    			}, 2000);
							}else{
								$("#msg").hide();
								$("#msg").fadeIn();
								$("#msg").css('color', "red");
								$("#msg").html(data.message);
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