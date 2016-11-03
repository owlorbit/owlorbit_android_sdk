/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
define(['app','jquery'], function(App, $) {
	require(['bootstrap', 'metismenu'], function(){
		require(['sbadmin', 'select2'], function(){
			var users = [];

			$("#add-users-board").select2({
				multiple: true,
				data: function() { return {results: users}; }
			});		       

			$("#s2id_add-users-board").keydown(function(evt){
				if(evt.keyCode == 9){
					$(this).focus();
					evt.preventDefault();
				}
			});

			function enableProjectLink(){
				$(".project-container").click(function(evt){
					var launchLink = $(evt.target);
					var projectId = launchLink.attr("data-id");

					if(launchLink.hasClass("project-name-label")){
						projectId = launchLink.closest(".project-container").attr("data-id");						
					}

					if(launchLink.hasClass("project-container") || launchLink.hasClass("project-name-label")){
						window.location.href = "/view/" + projectId;
					}
				});				
			}			

			function createProject(row, isPersonal){
				var html = "";

				if(isPersonal){
					html += '<li id="projectContainer' + row.id + '" class="projects-list-li-container">';
						html += '<div class="project-container" id="project' + row.id + '" data-id="' + row.id + '">';
							html += '<span class="project-name-label">' + row.name + '</span>';
							html += '<div style="float: right;">';
								html += '<div class="btn-group">';
				                            	html += '<a href="javascript: void(0);" class="menu-board" data-toggle="dropdown"><i class="fa fa-chevron-down fa-fw"></i></a>';
				                                html += '<ul class="dropdown-menu pull-right" role="menu">';
				                                    html += '<li><a href="/view/' + row.id + '">Open</a>';
				                                    html += '</li>';                                            
				                                    html += '<li class="divider"></li>';
				                                    html += '<li><a href="#" data-toggle="modal" data-target="#confirmDeleteModal" data-role="popup-delete-board">Delete</a>';                                            
				                                    html += '<input type="hidden" class="board-data" data-name="' + row.name + '" data-id="' + row.id + '"/>';
				                                    html += '</li>';
				                                html += '</ul>';
				                            html += '</div>';
			                html += "</div>";
						html += '</div>';
				html += '</li>';

				}else{
					html += '<li id="projectContainer' + row.id + '" class="projects-list-li-container">';
						html += '<div class="project-container" id="project' + row.id + '" data-id="' + row.id + '">';
							html += '<span class="project-name-label">' + row.name + '</span>';							
						html += '</div>';
				html += '</li>';
				}

				return html;
			}

			function deleteHandler(){

				$("[data-role='popup-delete-board']").unbind("click");
	    	    $("[data-role='popup-delete-board']").click(function(evt){
	    	    	var boardData = $(evt.target).siblings(".board-data");
	     			var boardId = boardData.attr("data-id");
	     			var boardName = boardData.attr("data-name");				

	     			$("#deleteBoardData").attr("data-id", boardId);
					$("#deleteBoardName").html(boardName);
	     		});

	    	    $("#delete-board-btn").unbind("click");
	     		$("#delete-board-btn").click(function(evt){
	     			var boardData = $("#deleteBoardData");
	     			var boardId = boardData.attr("data-id");
	     			if(boardId == ""){
	     				return;
	     			}

					var dataToBeSent = "id=" + boardId;
					$.ajax({
					    type: "POST",
					    url: "/board/delete",
					    data: dataToBeSent,				    
					    dataType: "json",
					    success: function(data){
							if(data.successful){
								//remove.. the board container...
								$("#projectContainer" + boardId).remove();
								$("#confirmDeleteModal").modal('hide');
							}else{
								$("#deleteBoardError").html(data.message);
							}
					    },
					    failure: function(errMsg) {
					        alert(errMsg);
					    }
					});     			
	     		});
	     	}

			$("#add-users-container .select2-input").keyup(function(evt){
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
								var displayText = value.firstName + " " + value.lastName + " (" + value.name + ")";
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
			

			$("#create-board-btn").click(function(){	
				
				var dataToBeSent = $("#create-board").serialize();
				$.ajax({
				    type: "POST",
				    url: "/board/submit",
				    data: dataToBeSent,				    
				    dataType: "json",
				    success: function(data){
				    
				    	if(data.successful){
							window.location.href = "/view/" + data.boardId;
						}else{
							$("#createBoardErrorContainer").hide();
							$("#createBoardError").html(data.message);
							$("#createBoardErrorContainer").fadeIn();
						}
				    },
				    failure: function(errMsg) {
				        alert(errMsg);
				    }
				  });

			});

			enableProjectLink();
			deleteHandler();
		});
	});
});