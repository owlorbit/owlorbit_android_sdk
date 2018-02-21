package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/4/18.
 */

@Generated("org.jsonschema2pojo")
public class ListMessageModel extends BaseApiResponseModel  {


    @SerializedName("messages")
    @Expose
    private List<Message> messages = new ArrayList<Message>();

    public List<Message> getMessages() {
        return messages;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }
}
