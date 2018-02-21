package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/1/18.
 */

@Generated("org.jsonschema2pojo")
public class ListAllGroupsModel extends BaseApiResponseModel  {

    @SerializedName("groups")
    @Expose
    private List<Group> groups = new ArrayList<Group>();

    public List<Group> getGroups() {
        return groups;
    }

    public void setGroups(List<Group> groups) {
        this.groups = groups;
    }
}
