package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.JsonElement;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import org.json.JSONObject;

import java.sql.Timestamp;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/2/18.
 */


@Generated("org.jsonschema2pojo")
public class Meetup {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("room_id")
    @Expose
    private int roomId;

    @SerializedName("title")
    @Expose
    private String title;

    @SerializedName("subtitle")
    @Expose
    private String subtitle;

    @SerializedName("longitude")
    @Expose
    private double longitude;

    @SerializedName("latitude")
    @Expose
    private double latitude;

    @SerializedName("metadata")
    @Expose
    private JsonElement metadata;

    @SerializedName("created")
    @Expose
    private String created;

    @SerializedName("active")
    @Expose
    private int active;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public JsonElement getMetadata() {
        return metadata;
    }

    public void setMetadata(JsonElement metadata) {
        this.metadata = metadata;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }
}
