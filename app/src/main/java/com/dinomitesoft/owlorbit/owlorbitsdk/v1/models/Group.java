package com.dinomitesoft.owlorbit.owlorbitsdk.v1.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.sql.Timestamp;

import javax.annotation.Generated;

/**
 * Created by timnuwin1 on 2/1/18.
 */

@Generated("org.jsonschema2pojo")
public class Group {


    @SerializedName("id")
    @Expose
    private int id;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("domain_id")
    @Expose
    private int domainId;

    @SerializedName("created")
    @Expose
    private String created;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDomainId() {
        return domainId;
    }

    public void setDomainId(int domainId) {
        this.domainId = domainId;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }
}
