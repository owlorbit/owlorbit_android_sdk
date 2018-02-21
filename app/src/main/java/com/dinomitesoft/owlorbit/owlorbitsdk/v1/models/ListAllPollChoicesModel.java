package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/5/18.
 */


@Generated("org.jsonschema2pojo")
public class ListAllPollChoicesModel extends BaseApiResponseModel {


    @SerializedName("polling_choices")
    @Expose
    private List<PollingChoice> polls = new ArrayList<PollingChoice>();


    public List<PollingChoice> getPolls() {
        return polls;
    }

    public void setPolls(List<PollingChoice> polls) {
        this.polls = polls;
    }
}
