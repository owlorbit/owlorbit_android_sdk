/*
Copyright 2014 - Taskfort Software
Created by Tim Nuwin
All Rights Reserved
Please refer to the End-User License Agreement (EULA) on https://www.taskfort.com/terms
*/
define(['app','jquery'], function(App, $) {
	require(['bootstrap', 'metismenu'], function(){
		require(['sbadmin', 'select2', 'jqueryui'], function(){

			var holdCard = null;
	    	var prevCards = [];
	    	var lockCards = false;

			function updateClickCardNameHandlers(){
				$(".card-name").unbind("click");
				$(".card-name").click(function(evt){							

					var boardId = $(this).closest(".card").attr("data-id");
					var cardName = $(this).children(".card-name-label").text();
					var cardOrder = $(this).closest(".card").attr("data-order");
					var cardUserId = $(this).closest(".card").attr("data-userId");

					if($(evt.target).hasClass("card-name-label")){
						$(evt.target).closest(".card-name").hide();
						$(evt.target).closest(".card-name").siblings(".card-name-input").children(".card-name-update").val(cardName);
						$(evt.target).closest(".card-name").siblings(".card-name-input").show();
						$(evt.target).closest(".card-name").siblings(".card-name-input").children(".card-name-update").focus();
					}else{
						$(this).hide();
						$(this).siblings(".card-name-input").children(".card-name-update").val(cardName);
						$(this).siblings(".card-name-input").show();
						$(this).siblings(".card-name-input").children(".card-name-update").focus();
					}
				});

				$(".card").unbind("click");
				$(".card").click(function(evt){
					var foundCard = false
					var parentCard = $(evt.target);
					while(!foundCard){
						if(parentCard.hasClass("card")){
							foundCard = true;
						}else{
							parentCard = parentCard.parent();
						}
					}
					
					if($(evt.target).hasClass("card-name-update") || $(evt.target).hasClass("card-name") || $(evt.target).hasClass("card-name-label")){
					}else{
						defaultView();				
					}

					if($(evt.target).hasClass("add-task-input") || $(evt.target).hasClass("add-task")){					
					}else{
						hideAddTask(this);
					}

				});		
			}

			function updateCardNameInputLoseFocusHandlers(){
				$(".card-name-update").unbind("focusout");
				$(".card-name-update").focusout(function(evt){
					defaultCardNameView(this);
				});

				$(".card-name-update").unbind("keyup");
				$(".card-name-update").keyup(function(evt){				
					if(evt.keyCode === 13){
						defaultCardNameView(this);
					}
				});
			}		

			function defaultCardNameView(val){
				var cardName = $(val).val().trim();
				var cardId = $(val).closest(".card").attr("data-id");

				$(val).parent(".card-name-input").siblings(".card-name").children('.card-name-label').html(cardName);
				$(val).parent(".card-name-input").hide();
				$(val).parent(".card-name-input").siblings(".card-name").show();

				updateCardOrder(null, null);
			}

			function hideAddTask(val){
				$(".add-task-input-container").hide();
				$(".add-task-input-container").siblings(".add-task").show();
			}

			function defaultView(){			
				$(".card-name-input").hide();
				$(".card-name-input").siblings(".card-name").show();
			}

			function cardDeletePopup(){
				$("[data-role='popup-delete-card']").unbind("click");
	    	    $("[data-role='popup-delete-card']").click(function(evt){
	    	    	var cardData = $(evt.target).siblings(".card-data");
	     			var cardId = cardData.attr("data-id");
	     			$("#deleteCardData").attr("data-id", cardId);
	     		});
			}

			function deleteCardHandler(){
				$("#delete-card-btn").unbind("click");
	     		$("#delete-card-btn").click(function(evt){
	     			var cardData = $("#deleteCardData");
	     			var cardId = cardData.attr("data-id");
					$("#card" + cardId).remove();

					var currentCards = $("#card-container").sortable('toArray');
					var cardNames = [];
					for (var i = 0; i < currentCards.length; i++){
						var name = $("#" + currentCards[i]).find(".card-name-label").html();
						cardNames.push(name);
			    	}

					var dataToBeSent = { json:JSON.stringify({cards: cardNames}) };


					lockCards = true;
					$.ajax({
					    type: "POST",
					    url: "/settings/update_board_settings",
					    data: dataToBeSent,		    
					    dataType: "json",
					    success: function(data){
					    	lockCards = false;
					    	if(data.successful){								
	     						$("#confirmDeleteCardModal").modal('hide');
							}
					    },
					    failure: function(errMsg) {
					    	lockCards = false;
					        alert(errMsg);
					    }
					});
	     			
	     		});
	     	}

			function init(){
				$("[data-role='create-card']").click(function(event){
					createCard();
		    	});

				$(".new-card-input").keyup(function(evt){
					evt.preventDefault();
					if(evt.keyCode === 13){
						createCard();
					}
		    	});

				$("#card-container").sortable({	
		            connectWith: ".card",
		            cursor: "move",
		            items: ".card",            
		            update: updateCardOrder,
		            start: startCardOrder,
		        }).disableSelection();

		        cardDeletePopup();
		        deleteCardHandler();
		        updateClickCardNameHandlers();
		        updateCardNameInputLoseFocusHandlers();
		        updateWidth();
			}

			function updateWidth(){
				var cardCount = $(".card-container").length;
				var calculatedWidth = cardCount * (350 + 20);
				$("#inner-card-container").width(calculatedWidth + "px");
			}

			function startCardOrder(event, ui){
		        ui.placeholder.height(ui.item.height());
        		$("#inner-card-container").width(window.initialContainerWidth);
        		$(".card").addClass('card-drag');
	    	}

			function updateCardOrder(event, ui){
				if(lockCards){return;}		
				var currentCards = $("#card-container").sortable('toArray');
				var cardNames = [];
				for (var i = 0; i < currentCards.length; i++){
					var name = $("#" + currentCards[i]).find(".card-name-label").html();
					cardNames.push(name);
		    	}

				var dataToBeSent = { json:JSON.stringify({cards: cardNames}) };

				lockCards = true;
				$.ajax({
				    type: "POST",
				    url: "/settings/update_board_settings",
				    data: dataToBeSent,		    
				    dataType: "json",
				    success: function(data){
				    	console.log(data);
				    	lockCards = false;
				    	if(data.successful){

						}else{

						}
				    },
				    failure: function(errMsg) {
				    	lockCards = false;
				        alert(errMsg);
				    }
				});				
			}	   

			function createCard(){
				var cardVal = $(".new-card-input").val();
				
				if(cardVal == ""){
					return;
				}
				
				//get max card id..
				var currentCards = $("#card-container").sortable('toArray');
				var maxCardId = 0;
				for (var i = 0; i < currentCards.length; i++){
					currentId = currentCards[i].replace("card", "");
					if(currentId > maxCardId){
						maxCardId = currentId;
					}
		    	}
		    	maxCardId++;

		    	var cardHtml = '<ul id="card' + maxCardId + '" class="card card-container panel panel-primary" data-id="' + maxCardId	 + '" data-order="1" data-userId="1">' +			  
			      '<div class="card-name panel-heading">' +
			      	'<label class="card-name-label">' + cardVal + '</label>' +
			      	'<div class="menu pull-right">' +
	                        '<div class="btn-group">' +
	                        '<a href="javascript: void(0);" class="menu-board" data-toggle="dropdown"><i class="fa fa-chevron-down fa-fw"></i></a>' +
	                            '<ul class="dropdown-menu pull-right" role="menu">' +
	                                '<li><a href="#" data-toggle="modal" data-target="#confirmDeleteCardModal" data-role="popup-delete-card">Delete</a>' +
	                                '<input type="hidden" class="card-data" data-id="'+ maxCardId +'"/>' +
	                                '</li>' +
	                            '</ul>' +
	                        '</div>' +
	                    '</div>' +
			      '</div>' +
			      '<div class="card-name-input panel-heading" style="display:none;">' +
			      	'<input type="text" class="card-name-update" id="cardNameUpdate" placeholder="Name" value="' + cardVal + '">' +
			      '</div>' +
			      '<div class="panel-body">' +
				      "<ul class='tasks'>" +
			      "</ul>" +
			      '</div>' +
			      '<div class="panel-footer">' +		      
			      '</div>' +
				  '<div class="add-task-input-container panel-footer" style="display:none;">' +
				  	'<textarea class="add-task-input" id="addTaskInput" placeholder="Task"></textarea>' +
			      '</div>' +
			      '</ul>';

				$(".new-card-input").val("");
				$("#inner-card-container").append(cardHtml);
				$("#createCardModal").modal('hide');

				updateCardOrder();		
				updateWidth();		
		    }


	    	init();
		});
	});	
});