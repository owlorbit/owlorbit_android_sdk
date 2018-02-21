package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 1/30/18.
 */

@Generated("org.jsonschema2pojo")
public class ListAllRoomModel  extends BaseApiResponseModel {

    @SerializedName("rooms")
    @Expose
    private List<Room> rooms = new ArrayList<Room>();

    public List<Room> getUsers() {
        return rooms;
    }

    public void setRooms(List<Room> rooms) {
        this.rooms = rooms;
    }
}
