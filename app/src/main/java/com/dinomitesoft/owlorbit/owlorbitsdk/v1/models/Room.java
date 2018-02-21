package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 1/30/18.
 */

@Generated("org.jsonschema2pojo")
public class Room {

    @SerializedName("roomId")
    @Expose
    private String roomId;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("last_message")
    @Expose
    private String last_message;

    @SerializedName("is_public_channel")
    @Expose
    private int isPublicChannel;

    @SerializedName("last_display_name")
    @Expose
    private String lastDisplayName;

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLast_message() {
        return last_message;
    }

    public void setLast_message(String last_message) {
        this.last_message = last_message;
    }

    public int getIsPublicChannel() {
        return isPublicChannel;
    }

    public void setIsPublicChannel(int isPublicChannel) {
        this.isPublicChannel = isPublicChannel;
    }

    public String getLastDisplayName() {
        return lastDisplayName;
    }

    public void setLastDisplayName(String lastDisplayName) {
        this.lastDisplayName = lastDisplayName;
    }
}
