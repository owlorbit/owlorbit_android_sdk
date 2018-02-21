package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/4/18.
 */

@Generated("org.jsonschema2pojo")
public class CreateMessageModel extends BaseApiResponseModel {

    @SerializedName("message_id")
    @Expose
    private int messageId;

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }
}
