package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 1/29/18.
 */

@Generated("org.jsonschema2pojo")
public class User {

    @SerializedName("user_id")
    @Expose
    private String userId;

    @SerializedName("email")
    @Expose
    private String email;

    @SerializedName("phone_number")
    @Expose
    private String phoneNumber;

    @SerializedName("first_name")
    @Expose
    private String firstName;

    @SerializedName("last_name")
    @Expose
    private String lastName;

    @SerializedName("avatar")
    @Expose
    private String avatar;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
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

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}
