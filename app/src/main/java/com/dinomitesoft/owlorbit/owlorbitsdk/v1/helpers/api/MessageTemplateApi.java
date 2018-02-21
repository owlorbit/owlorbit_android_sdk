package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateMessageTemplateModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllGroupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListMessageTemplateModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.UpdateMessageTemplateModel;

import java.util.ArrayList;

import retrofit.Call;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.POST;

import static com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.CommonResource.API_VERSION;

/**
 * Created by timnuwin1 on 2/4/18.
 */

public class MessageTemplateApi {

    public interface ListMessageTemplatesDelegate {
        public void success(ListMessageTemplateModel response);
        public void error(String response);
    }

    public interface CreateMessageTemplatesDelegate {
        public void success(CreateMessageTemplateModel response);
        public void error(String response);
    }

    public interface UpdateMessageTemplatesDelegate {
        public void success(UpdateMessageTemplateModel response);
        public void error(String response);
    }

    public interface MessageTemplateService {
        @FormUrlEncoded
        @POST(API_VERSION + "/message_template/view")
        Call<ListMessageTemplateModel> list(@Field("publicKey") String publicKey,
                                               @Field("encryptedSession") String encryptedSession,
                                               @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/message_template/create")
        Call<CreateMessageTemplateModel> create(@Field("choices[]") ArrayList<String> choices,
                                            @Field("templateName") String templateName,
                                            @Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/message_template/create")
        Call<CreateMessageTemplateModel> create(@Field("choices[]") ArrayList<String> choices,
                                                @Field("templateName") String templateName,
                                                @Field("groupId") int groupId,
                                                @Field("publicKey") String publicKey,
                                                @Field("encryptedSession") String encryptedSession,
                                                @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/message_template/update")
        Call<UpdateMessageTemplateModel> update(@Field("messageTemplateId") int messageTemplateId,
                                                @Field("choices[]") ArrayList<String> choices,
                                                @Field("templateName") String templateName,
                                                @Field("publicKey") String publicKey,
                                                @Field("encryptedSession") String encryptedSession,
                                                @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/message_template/update")
        Call<UpdateMessageTemplateModel> update(@Field("messageTemplateId") int messageTemplateId,
                                                @Field("choices[]") ArrayList<String> choices,
                                                @Field("templateName") String templateName,
                                                @Field("groupId") int groupId,
                                                @Field("publicKey") String publicKey,
                                                @Field("encryptedSession") String encryptedSession,
                                                @Field("sessionHash") String sessionHash);
    }

    public static void update(int messageTemplateId, ArrayList<String> choices, String templateName, final UpdateMessageTemplatesDelegate delegate){

        MessageTemplateService api = ApiClientHelper.getRetroFit().create(MessageTemplateService.class);
        Call<UpdateMessageTemplateModel> myCall = api.update(messageTemplateId, choices, templateName, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<UpdateMessageTemplateModel>() {

            @Override
            public void onResponse(Response<UpdateMessageTemplateModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void update(int messageTemplateId, ArrayList<String> choices, String templateName, int groupId, final UpdateMessageTemplatesDelegate delegate){

        MessageTemplateService api = ApiClientHelper.getRetroFit().create(MessageTemplateService.class);
        Call<UpdateMessageTemplateModel> myCall = api.update(messageTemplateId, choices, templateName, groupId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<UpdateMessageTemplateModel>() {

            @Override
            public void onResponse(Response<UpdateMessageTemplateModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


    public static void create(ArrayList<String> choices, String templateName, final CreateMessageTemplatesDelegate delegate){

        MessageTemplateService api = ApiClientHelper.getRetroFit().create(MessageTemplateService.class);
        Call<CreateMessageTemplateModel> myCall = api.create(choices, templateName, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateMessageTemplateModel>() {

            @Override
            public void onResponse(Response<CreateMessageTemplateModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void create(ArrayList<String> choices, String templateName, int groupId, final CreateMessageTemplatesDelegate delegate){

        MessageTemplateService api = ApiClientHelper.getRetroFit().create(MessageTemplateService.class);
        Call<CreateMessageTemplateModel> myCall = api.create(choices, templateName, groupId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateMessageTemplateModel>() {

            @Override
            public void onResponse(Response<CreateMessageTemplateModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


    public static void list(final ListMessageTemplatesDelegate delegate){
        MessageTemplateService api = ApiClientHelper.getRetroFit().create(MessageTemplateService.class);
        Call<ListMessageTemplateModel> myCall = api.list(ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListMessageTemplateModel>() {

            @Override
            public void onResponse(Response<ListMessageTemplateModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

}
