package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/4/18.
 */

@Generated("org.jsonschema2pojo")
public class Message {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("first_name")
    @Expose
    private String firstName;

    @SerializedName("last_name")
    @Expose
    private String lastName;

    @SerializedName("user_id")
    @Expose
    private int userId;

    @SerializedName("date_in_utc")
    @Expose
    private String dateInUtc;

    @SerializedName("message")
    @Expose
    private String message;

    @SerializedName("avatar")
    @Expose
    private String avatar;

    @SerializedName("room_id")
    @Expose
    private int roomId;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDateInUtc() {
        return dateInUtc;
    }

    public void setDateInUtc(String dateInUtc) {
        this.dateInUtc = dateInUtc;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
}
