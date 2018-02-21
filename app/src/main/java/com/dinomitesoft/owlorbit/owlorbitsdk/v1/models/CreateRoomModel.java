package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 1/31/18.
 */

@Generated("org.jsonschema2pojo")
public class CreateRoomModel extends BaseApiResponseModel {

    @SerializedName("room_id")
    @Expose
    private int roomId;

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
}
