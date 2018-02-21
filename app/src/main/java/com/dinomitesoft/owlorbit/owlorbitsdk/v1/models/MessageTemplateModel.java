package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/4/18.
 */

@Generated("org.jsonschema2pojo")
public class MessageTemplateModel {

    @SerializedName("message_template_id")
    @Expose
    private int messageTemplateId;

    @SerializedName("group_id")
    @Expose
    private int groupId;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("choice")
    @Expose
    private String choice;

    public int getMessageTemplateId() {
        return messageTemplateId;
    }

    public void setMessageTemplateId(int messageTemplateId) {
        this.messageTemplateId = messageTemplateId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getChoice() {
        return choice;
    }

    public void setChoice(String choice) {
        this.choice = choice;
    }
}
