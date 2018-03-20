package com.dinomitesoft.owlorbit.owlorbitsdkexample;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebView;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.Owlorbit;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.CommonResource;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.GroupApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.LocationApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.MeetupApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.MessageApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.MessageTemplateApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.PollingApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.RoomApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.UserApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.AddUserDomainModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateGroupModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateMeetupModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateMessageModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateMessageTemplateModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreatePollModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateRoomModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.DoesEmailExistModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllGroupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllLocationsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllMeetupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllPollChoicesModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllPollsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllRoomModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllUserModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListMessageModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListMessageTemplateModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListPollingResponsesModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.UpdateMessageTemplateModel;
import com.google.gson.Gson;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MainActivity extends AppCompatActivity {

    @Bind(R.id.webview)
    WebView webview;

    Owlorbit owlorbit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ButterKnife.bind(this);
        owlorbit = new Owlorbit(this, "", "", "");
    }

    @OnClick(R.id.btnListAllUsers)
    void btnListAllUsersClick() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllUsers(new UserApi.ListAllUsersDelegate() {
            @Override
            public void success(ListAllUserModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnDoesUserExist)
    void btnDoesUserExist() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().doesEmailExist("z1", "test965@test.com", new UserApi.EmailExistDelegate() {
            @Override
            public void success(DoesEmailExistModel doesEmailExistModel) {
                Gson gson = new Gson();
                String json = gson.toJson(doesEmailExistModel);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnAddUserToDomain)
    void btnAddUserToDomain() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().addUserToDomain("test965@test.com", "test",
            "Bob", "Burger", "555-123-1234", new UserApi.AddUserDelegate(){

                @Override
                public void success(AddUserDomainModel addUserDomainModel) {
                    Gson gson = new Gson();
                    String json = gson.toJson(addUserDomainModel);
                    webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
                }

                    @Override
                public void error(String response) {
                    webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
                }
            });
    }

    @OnClick(R.id.btnGetRoomsInDomain)
    void btnGetRoomsInDomain() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllRoomsInDomain(new RoomApi.ListAllRoomsDelegate() {
            @Override
            public void success(ListAllRoomModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnGetRoomsByEmail)
    void btnGetRoomsByEmail() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllRoomsByEmail("timnuwin@gmail.com", new RoomApi.ListAllRoomsDelegate() {
            @Override
            public void success(ListAllRoomModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnJoinRoomByEmail)
    void btnJoinRoomByEmail() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().joinRoom(12, "test@test.com", new RoomApi.JoinRoomDelegate() {

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnCreateRoom)
    void btnCreateRoom() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        ArrayList<Integer> userIds = new ArrayList<>(Arrays.asList(1));
        owlorbit.getApi().createRoom(userIds,
                "test@test.com",
                "Room created by API (android)",
                0, 0, new RoomApi.CreateRoomDelegate() {

            @Override
            public void success(CreateRoomModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnListAllLocations)
    void btnListAllLocations() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");

        owlorbit.getApi().listAllLocations(new LocationApi.ListAllLocationsDelegate() {
            @Override
            public void success(ListAllLocationsModel response) {

                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnListAllLocationsByEmail)
    void btnListAllLocationsByEmail() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllLocationsByEmail("test@test.com", new LocationApi.ListAllLocationsDelegate(){

            @Override
            public void success(ListAllLocationsModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnListAllUsersInRoom)
    void btnListAllUsersInRoom() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllLocationsByRoomId(222, new LocationApi.ListAllLocationsDelegate(){

            @Override
            public void success(ListAllLocationsModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }


    @OnClick(R.id.btnAddUserLocation)
    void btnAddUserLocation() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        JSONObject metadata = new JSONObject();

        try {
            metadata.put("key", "value");
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        owlorbit.getApi().addLocation("test@test.com", 12.02, 144.05, metadata, new LocationApi.AddLocationsDelegate(){

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }


    @OnClick(R.id.btnListAllGroups)
    void btnListAllGroups() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllGroups(new GroupApi.ListAllGroupsDelegate(){

            @Override
            public void success(ListAllGroupsModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnCreateGroup)
    void btnCreateGroup() {

        ArrayList<Integer> userIds = new ArrayList<>(Arrays.asList(682, 684));
        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().createGroup(userIds, "Group Created by API (Android)", new GroupApi.CreateGroupDelegate(){

            @Override
            public void success(CreateGroupModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnUpdateGroup)
    void btnUpdateGroup() {

        //ArrayList<Integer> userIds = new ArrayList<>(Arrays.asList(682));
        ArrayList<Integer> userIds = new ArrayList<Integer>();
        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().updateGroup(13, userIds, new GroupApi.UpdateGroupDelegate(){

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnListAllMeetUps)
    void btnListAllMeetUps() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllMeetups(226, new MeetupApi.ListAllMeetupsDelegate(){

            @Override
            public void success(ListAllMeetupsModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }


    @OnClick(R.id.btnListAllMeetUpsByEmail)
    void btnListAllMeetUpsByEmail() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listAllMeetups("test@test.com", new MeetupApi.ListAllMeetupsDelegate(){

            @Override
            public void success(ListAllMeetupsModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }


    @OnClick(R.id.btnAddMeetupPoint)
    void btnAddMeetupPoint() {

        JSONObject metadata = new JSONObject();
        try {
            metadata.put("key", "value");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().addMeetup("test@test.com", "Meetup Point (android sdk)", "subtitle", 222, 23.4f, 21.f, 0, metadata, new MeetupApi.AddMeetupDelegate(){

            @Override
            public void success(CreateMeetupModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnUpdateMeetup)
    void btnUpdateMeetup() {

        JSONObject metadata = new JSONObject();
        try {
            metadata.put("key", "value");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().updateMeetup(1, 23.4f, 21.f, metadata, new MeetupApi.MeetupDelegate(){

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnDisableMeetup)
    void btnDisableMeetup() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().disableMeetup(211, new MeetupApi.MeetupDelegate(){

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnListMessages)
    void btnListMessages() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listMessages(222, 0, new MessageApi.ListMessagesDelegate() {
            @Override
            public void success(ListMessageModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnSendMessage)
    void btnSendMessage() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().sendMessage(1, "Send Message (android sdk)", new MessageApi.CreateMessageDelegate() {

            @Override
            public void success(CreateMessageModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnSendMessageFromEmail)
    void btnSendMessageFromEmail() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().sendMessageByEmail(1, "test@test.com", "Send Message (android sdk)", new MessageApi.CreateMessageDelegate() {

            @Override
            public void success(CreateMessageModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnMessageListTemplates)
    void btnMessageListTemplates() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listMessageTemplate(new MessageTemplateApi.ListMessageTemplatesDelegate() {

            @Override
            public void success(ListMessageTemplateModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnCreateMessageTemplate)
    void btnCreateMessageTemplate() {

        ArrayList<String> choices = new ArrayList<String>();
        choices.add("Yes");
        choices.add("No");

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().createMessageTemplate(choices, "Message Template (Android SDK)", 13, new MessageTemplateApi.CreateMessageTemplatesDelegate() {

            @Override
            public void success(CreateMessageTemplateModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnUpdateMessageTemplate)
    void btnUpdateMessageTemplate() {

        ArrayList<String> choices = new ArrayList<String>();
        choices.add("Yes");
        choices.add("No");

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().updateMessageTemplate(42, choices, "Message Template (Android SDK)", 13, new MessageTemplateApi.UpdateMessageTemplatesDelegate() {

            @Override
            public void success(UpdateMessageTemplateModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }


    @OnClick(R.id.btnListAllRunningPolls)
    void btnListAllRunningPolls() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listRunningPolls(new PollingApi.ListAllPollsDelegate() {

            @Override
            public void success(ListAllPollsModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnPollGetChoicesById)
    void btnPollGetChoicesById() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listPollingChoices(26, new PollingApi.ListAllPollChoicesDelegate() {

            @Override
            public void success(ListAllPollChoicesModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnGetPollResponses)
    void btnGetPollResponses() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().listPollingResponses(57, new PollingApi.ListPollResponsesDelegate() {

            @Override
            public void success(ListPollingResponsesModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnCreatePoll)
    void btnCreatePoll() {

        ArrayList<String> choices = new ArrayList<String>();
        choices.add("Yes");
        choices.add("No");

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().createPoll(choices, "Test Poll (Android SDK)", 13, 0,  new PollingApi.CreatePollDelegate() {

            @Override
            public void success(CreatePollModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnCreateFuturePoll)
    void btnCreateFuturePoll() {

        ArrayList<String> choices = new ArrayList<String>();
        choices.add("Yes");
        choices.add("No");

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().createPoll(choices, "Test Poll (Android SDK)", "2521402136000", 13, 0,  new PollingApi.CreatePollDelegate() {

            @Override
            public void success(CreatePollModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnCancelPoll)
    void btnCancelPoll() {

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().cancelPoll(46, new PollingApi.CancelPollDelegate() {

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }

    @OnClick(R.id.btnSendPollResponse)
    void btnSendPollResponse() {

        ArrayList<String> choices = new ArrayList<String>();
        choices.add("Yes");
        choices.add("No");

        webview.loadDataWithBaseURL("", "Loading...", "text/html", "UTF-8", "");
        owlorbit.getApi().submitPollChoice(26, "test@test.com", 57, new PollingApi.SendPollDelegate() {

            @Override
            public void success(BaseApiResponseModel response) {
                Gson gson = new Gson();
                String json = gson.toJson(response);
                webview.loadDataWithBaseURL("", json, "text/html", "UTF-8", "");
            }

            @Override
            public void error(String response) {
                webview.loadDataWithBaseURL("", response, "text/html", "UTF-8", "");
            }
        });
    }
}
