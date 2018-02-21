package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.sql.Timestamp;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/5/18.
 */

@Generated("org.jsonschema2pojo")
public class PollingResponse {

    @SerializedName("polling_id")
    @Expose
    private int pollingId;

    @SerializedName("polling_choice_id")
    @Expose
    private int pollingChoiceId;

    @SerializedName("user_id")
    @Expose
    private int userId;

    @SerializedName("first_name")
    @Expose
    private String firstName;

    @SerializedName("last_name")
    @Expose
    private String lastName;

    @SerializedName("email")
    @Expose
    private String email;

    @SerializedName("avatar")
    @Expose
    private String avatar;

    @SerializedName("created")
    @Expose
    private String created;

    public int getPollingId() {
        return pollingId;
    }

    public void setPollingId(int pollingId) {
        this.pollingId = pollingId;
    }

    public int getPollingChoiceId() {
        return pollingChoiceId;
    }

    public void setPollingChoiceId(int pollingChoiceId) {
        this.pollingChoiceId = pollingChoiceId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }
}
