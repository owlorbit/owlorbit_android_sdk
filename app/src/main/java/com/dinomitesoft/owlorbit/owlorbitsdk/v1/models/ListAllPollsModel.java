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
public class ListAllPollsModel extends BaseApiResponseModel {

    @SerializedName("polls")
    @Expose
    private List<Poll> polls = new ArrayList<Poll>();

    public List<Poll> getPolls() {
        return polls;
    }

    public void setPolls(List<Poll> polls) {
        this.polls = polls;
    }
}
