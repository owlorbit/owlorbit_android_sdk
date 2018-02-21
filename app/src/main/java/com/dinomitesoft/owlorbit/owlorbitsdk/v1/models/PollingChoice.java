package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/5/18.
 */

@Generated("org.jsonschema2pojo")
public class PollingChoice {

    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("polling_id")
    @Expose
    private int pollingId;

    @SerializedName("choice")
    @Expose
    private String choice;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPollingId() {
        return pollingId;
    }

    public void setPollingId(int pollingId) {
        this.pollingId = pollingId;
    }

    public String getChoice() {
        return choice;
    }

    public void setChoice(String choice) {
        this.choice = choice;
    }
}
