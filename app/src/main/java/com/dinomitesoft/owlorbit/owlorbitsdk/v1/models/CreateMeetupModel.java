package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/2/18.
 */

@Generated("org.jsonschema2pojo")
public class CreateMeetupModel extends BaseApiResponseModel  {

    @SerializedName("meetup_id")
    @Expose
    private int meetupId;

    public int getMeetupId() {
        return meetupId;
    }

    public void setMeetupId(int meetupId) {
        this.meetupId = meetupId;
    }
}
