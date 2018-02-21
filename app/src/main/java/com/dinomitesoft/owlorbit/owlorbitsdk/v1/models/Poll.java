package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/5/18.
 */

@Generated("org.jsonschema2pojo")
public class Poll {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("user_id")
    @Expose
    private int userId;

    @SerializedName("group_id")
    @Expose
    private int groupId;

    @SerializedName("question")
    @Expose
    private String question;

    @SerializedName("manual_location_request_enabled")
    @Expose
    private int manualLocationRequestEnabled;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public int getManualLocationRequestEnabled() {
        return manualLocationRequestEnabled;
    }

    public void setManualLocationRequestEnabled(int manualLocationRequestEnabled) {
        this.manualLocationRequestEnabled = manualLocationRequestEnabled;
    }
}
