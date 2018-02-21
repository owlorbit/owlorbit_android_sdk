package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 1/31/18.
 */

@Generated("org.jsonschema2pojo")
public class ListAllLocationsModel extends BaseApiResponseModel {

    @SerializedName("locations")
    @Expose
    private List<Location> locations = new ArrayList<Location>();

    public List<Location> getLocations() {
        return locations;
    }

    public void setLocations(List<Location> locations) {
        this.locations = locations;
    }
}
