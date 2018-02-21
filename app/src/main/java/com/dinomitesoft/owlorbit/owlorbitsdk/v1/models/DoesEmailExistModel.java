package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 1/29/18.
 */

@Generated("org.jsonschema2pojo")
public class DoesEmailExistModel extends BaseApiResponseModel {

    @SerializedName("emailExists")
    @Expose
    private Boolean emailExists;


    public Boolean isEmailExists() {
        return emailExists;
    }
    public void setEmailExists(Boolean emailExists) {
        this.emailExists = emailExists;
    }
}
