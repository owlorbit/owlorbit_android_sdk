package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import android.content.Context;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by timnuwin1 on 1/28/18.
 */

public class OwlorbitApi {
    private Context mContext;

    public OwlorbitApi(Context context, String publicKey, String encryptedSession, String sessionHash) {
        mContext = context;

        ApiSharedHelper.getInstance().setPublicKey(publicKey);
        ApiSharedHelper.getInstance().setSessionHash(sessionHash);
        ApiSharedHelper.getInstance().setEncryptedSession(encryptedSession);
    }

    public void doesEmailExist(String domain, String email, UserApi.EmailExistDelegate delegate) {
        UserApi.doesEmailExist(domain, email, delegate);
    }

    public void addUserToDomain(String email, String password,
                                String firstName, String lastName,
                                String phoneNumber, UserApi.AddUserDelegate delegate) {
        UserApi.addUserToDomain(email, password, firstName, lastName, phoneNumber, delegate);
    }

    public void listAllUsers(UserApi.ListAllUsersDelegate delegate) {
        UserApi.listAllUsers(delegate);
    }

    public void listAllRoomsByEmail(String email, RoomApi.ListAllRoomsDelegate delegate) {
        RoomApi.listAllRooms(email, delegate);
    }

    public void listAllRoomsInDomain(RoomApi.ListAllRoomsDelegate delegate) {
        RoomApi.listAllRooms(delegate);
    }

    public void joinRoom(int roomId, String email, RoomApi.JoinRoomDelegate delegate) {
        RoomApi.joinRoom(roomId, email, delegate);
    }

    public void createRoom(ArrayList<Integer> userIds,
                           String email,
                           String name,
                           int isFriendsOnly,
                           int isPublic,
                           int messageTemplateId, RoomApi.CreateRoomDelegate delegate) {
        RoomApi.createRoom(userIds, email, name, isFriendsOnly, isPublic, messageTemplateId, delegate);
    }

    public void createRoom(ArrayList<Integer> userIds,
                           String email,
                           String name,
                           int isFriendsOnly,
                           int isPublic,
                           RoomApi.CreateRoomDelegate delegate) {
        RoomApi.createRoom(userIds, email, name, isFriendsOnly, isPublic, delegate);
    }

    public void listAllLocations(LocationApi.ListAllLocationsDelegate delegate) {
        LocationApi.listAllLocations(delegate);
    }

    public void listAllLocationsByEmail(String email, LocationApi.ListAllLocationsDelegate delegate) {
        LocationApi.listAllLocations(email, delegate);
    }

    public void listAllLocationsByRoomId(int roomId, LocationApi.ListAllLocationsDelegate delegate) {
        LocationApi.listAllLocationsByRoomId(roomId, delegate);
    }

    public void addLocation(String email, double longitude, double latitude, LocationApi.AddLocationsDelegate delegate) {
        LocationApi.add(email, longitude, latitude, delegate);
    }

    public void addLocation(String email, double longitude, double latitude, double altitude, LocationApi.AddLocationsDelegate delegate) {
        LocationApi.add(email, longitude, latitude, altitude, delegate);
    }

    public void addLocation(String email, double longitude, double latitude, JSONObject metadata, LocationApi.AddLocationsDelegate delegate) {
        LocationApi.add(email, longitude, latitude, metadata, delegate);
    }

    public void addLocation(String email, double longitude, double latitude, double altitude, JSONObject metadata, LocationApi.AddLocationsDelegate delegate) {
        LocationApi.add(email, longitude, latitude, altitude, metadata, delegate);
    }

    public void listAllGroups(GroupApi.ListAllGroupsDelegate delegate) {
        GroupApi.listAllGroups(delegate);
    }

    public void createGroup(ArrayList<Integer> usersAdded, String groupName, GroupApi.CreateGroupDelegate delegate) {
        GroupApi.create(usersAdded, groupName, delegate);
    }

    public void updateGroup(int groupId, ArrayList<Integer> usersAdded, GroupApi.UpdateGroupDelegate delegate) {
        GroupApi.update(groupId, usersAdded, delegate);
    }

    public void listAllMeetups(int roomId, MeetupApi.ListAllMeetupsDelegate delegate) {
        MeetupApi.listAllMeetups(roomId, delegate);
    }

    public void listAllMeetups(String email, MeetupApi.ListAllMeetupsDelegate delegate) {
        MeetupApi.listAllMeetups(email, delegate);
    }

    public void addMeetup(String email, String title, String subtitle, int roomId,
                           float longitude, float latitude,  int isGlobal, MeetupApi.AddMeetupDelegate delegate) {
        MeetupApi.add(email, title, subtitle, roomId, longitude, latitude, isGlobal, delegate);
    }

    public void addMeetup(String email, String title, String subtitle, int roomId,
                          float longitude, float latitude,  int isGlobal, JSONObject metadata, MeetupApi.AddMeetupDelegate delegate) {
        MeetupApi.add(email, title, subtitle, roomId, longitude, latitude, isGlobal, metadata, delegate);
    }

    public void updateMeetup(int meetupId, float longitude, float latitude,  JSONObject metadata, MeetupApi.MeetupDelegate delegate) {
        MeetupApi.update(meetupId, longitude, latitude, metadata, delegate);
    }

    public void updateMeetup(int meetupId, float longitude, float latitude, MeetupApi.MeetupDelegate delegate) {
        MeetupApi.update(meetupId, longitude, latitude, delegate);
    }

    public void disableMeetup(int meetupId, MeetupApi.MeetupDelegate delegate) {
        MeetupApi.disable(meetupId, delegate);
    }

    public void listMessages(int roomId, int pageIndex, MessageApi.ListMessagesDelegate delegate) {
        MessageApi.list(roomId, pageIndex, delegate);
    }

    public void sendMessage(int roomId, String message, MessageApi.CreateMessageDelegate delegate) {
        MessageApi.send(roomId, message, delegate);
    }

    public void sendMessageByEmail(int roomId, String email, String message, MessageApi.CreateMessageDelegate delegate) {
        MessageApi.send(roomId, email, message, delegate);
    }

    public void listMessageTemplate(MessageTemplateApi.ListMessageTemplatesDelegate delegate) {
        MessageTemplateApi.list(delegate);
    }

    public void createMessageTemplate(ArrayList<String> choices, String templateName, MessageTemplateApi.CreateMessageTemplatesDelegate delegate) {
        MessageTemplateApi.create(choices, templateName, delegate);
    }

    public void createMessageTemplate(ArrayList<String> choices, String templateName, int groupId, MessageTemplateApi.CreateMessageTemplatesDelegate delegate) {
        MessageTemplateApi.create(choices, templateName, groupId, delegate);
    }

    public void updateMessageTemplate(int messageTemplateId, ArrayList<String> choices, String templateName, MessageTemplateApi.UpdateMessageTemplatesDelegate delegate) {
        MessageTemplateApi.update(messageTemplateId, choices, templateName, delegate);
    }

    public void updateMessageTemplate(int messageTemplateId, ArrayList<String> choices, String templateName, int groupId, MessageTemplateApi.UpdateMessageTemplatesDelegate delegate) {
        MessageTemplateApi.update(messageTemplateId, choices, templateName, groupId, delegate);
    }

    public void listRunningPolls(PollingApi.ListAllPollsDelegate delegate) {
        PollingApi.listRunning(delegate);
    }

    public void listPollingChoices(int pollingId, PollingApi.ListAllPollChoicesDelegate delegate) {
        PollingApi.listPollingChoices(pollingId, delegate);
    }

    public void listPollingResponses(int pollingChoiceId, final PollingApi.ListPollResponsesDelegate delegate) {
        PollingApi.listPollingResponses(pollingChoiceId, delegate);
    }

    public void createPoll(ArrayList<String> choices, String question, int groupId, int manualLocationEnabled, final PollingApi.CreatePollDelegate delegate) {
        PollingApi.create(choices, question, groupId, manualLocationEnabled, delegate);
    }

    public void createPoll(ArrayList<String> choices, String question, int manualLocationEnabled, final PollingApi.CreatePollDelegate delegate) {
        PollingApi.create(choices, question, manualLocationEnabled, delegate);
    }

    public void submitPollChoice(int pollingId, String email, int choiceId, final PollingApi.SendPollDelegate delegate) {
        PollingApi.submitPollChoice(pollingId, email, choiceId, delegate);
    }
}
