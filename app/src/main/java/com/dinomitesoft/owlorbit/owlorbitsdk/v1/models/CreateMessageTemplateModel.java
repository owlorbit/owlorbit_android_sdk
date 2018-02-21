package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/4/18.
 */

@Generated("org.jsonschema2pojo")
public class CreateMessageTemplateModel extends BaseApiResponseModel {

    @SerializedName("message_template_id")
    @Expose
    private int messageTemplateId;

    public int getMessageTemplateId() {
        return messageTemplateId;
    }

    public void setMessageTemplateId(int messageTemplateId) {
        this.messageTemplateId = messageTemplateId;
    }
}
