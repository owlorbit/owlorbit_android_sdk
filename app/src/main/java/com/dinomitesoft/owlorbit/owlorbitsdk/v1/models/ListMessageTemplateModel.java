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
public class ListMessageTemplateModel extends BaseApiResponseModel {

    @SerializedName("templates")
    @Expose
    private List<MessageTemplateModel> templates = new ArrayList<MessageTemplateModel>();

    public List<MessageTemplateModel> getTemplates() {
        return templates;
    }

    public void setTemplates(List<MessageTemplateModel> templates) {
        this.templates = templates;
    }
}
