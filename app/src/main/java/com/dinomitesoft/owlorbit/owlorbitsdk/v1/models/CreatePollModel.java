package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/5/18.
 */

@Generated("org.jsonschema2pojo")
public class CreatePollModel extends  BaseApiResponseModel {

    @SerializedName("polling_id")
    @Expose
    private int pollingId;

    public int getPollingId() {
        return pollingId;
    }

    public void setPollingId(int pollingId) {
        this.pollingId = pollingId;
    }
}
