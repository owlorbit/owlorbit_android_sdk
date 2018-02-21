package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/2/18.
 */

@Generated("org.jsonschema2pojo")
public class ListAllMeetupsModel extends BaseApiResponseModel  {

    @SerializedName("meetup_locations")
    @Expose
    private List<Meetup> meetupLocations = new ArrayList<Meetup>();

    public List<Meetup> getMeetupLocations() {
        return meetupLocations;
    }

    public void setMeetupLocations(List<Meetup> meetupLocations) {
        this.meetupLocations = meetupLocations;
    }
}
