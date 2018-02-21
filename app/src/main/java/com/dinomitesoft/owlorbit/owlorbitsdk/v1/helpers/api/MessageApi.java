package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateMessageModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllGroupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllMeetupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListMessageModel;

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

public class MessageApi {

    public interface ListMessagesDelegate {
        public void success(ListMessageModel response);
        public void error(String response);
    }

    public interface CreateMessageDelegate {
        public void success(CreateMessageModel response);
        public void error(String response);
    }

    public interface MessageService {
        @FormUrlEncoded
        @POST(API_VERSION + "/message/view")
        Call<ListMessageModel> list(@Field("roomId") int roomId,
                                @Field("pageIndex") int pageIndex,
                                @Field("publicKey") String publicKey,
                                @Field("encryptedSession") String encryptedSession,
                                @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/message/send")
        Call<CreateMessageModel> send(@Field("roomId") int roomId,
                                    @Field("message") String message,
                                    @Field("publicKey") String publicKey,
                                    @Field("encryptedSession") String encryptedSession,
                                    @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/message/send")
        Call<CreateMessageModel> send(@Field("roomId") int roomId,
                                      @Field("email") String email,
                                      @Field("message") String message,
                                      @Field("publicKey") String publicKey,
                                      @Field("encryptedSession") String encryptedSession,
                                      @Field("sessionHash") String sessionHash);
    }

    public static void send(int roomId, String message, final CreateMessageDelegate delegate){
        MessageService api = ApiClientHelper.getRetroFit().create(MessageService.class);
        Call<CreateMessageModel> myCall = api.send(roomId, message, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateMessageModel>() {

            @Override
            public void onResponse(Response<CreateMessageModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void send(int roomId, String email, String message, final CreateMessageDelegate delegate){
        MessageService api = ApiClientHelper.getRetroFit().create(MessageService.class);
        Call<CreateMessageModel> myCall = api.send(roomId, email, message, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateMessageModel>() {

            @Override
            public void onResponse(Response<CreateMessageModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


    public static void list(int roomId, int pageIndex, final ListMessagesDelegate delegate){
        MessageService api = ApiClientHelper.getRetroFit().create(MessageService.class);
        Call<ListMessageModel> myCall = api.list(roomId, pageIndex, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListMessageModel>() {

            @Override
            public void onResponse(Response<ListMessageModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

}
