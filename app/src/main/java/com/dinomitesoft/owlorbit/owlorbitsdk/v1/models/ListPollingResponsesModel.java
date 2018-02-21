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
public class ListPollingResponsesModel extends BaseApiResponseModel {

    @SerializedName("responses")
    @Expose
    private List<PollingResponse> pollingResponses = new ArrayList<PollingResponse>();

    public List<PollingResponse> getPollingResponses() {
        return pollingResponses;
    }

    public void setPollingResponses(List<PollingResponse> pollingResponses) {
        this.pollingResponses = pollingResponses;
    }
}
