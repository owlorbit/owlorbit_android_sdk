package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateMeetupModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllMeetupsModel;

import org.json.JSONObject;

import retrofit.Call;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.POST;

import static com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.CommonResource.API_VERSION;

/**
 * Created by timnuwin1 on 2/2/18.
 */

public class MeetupApi {

    public interface ListAllMeetupsDelegate {
        public void success(ListAllMeetupsModel response);
        public void error(String response);
    }

    public interface AddMeetupDelegate {
        public void success(CreateMeetupModel response);
        public void error(String response);
    }

    public interface MeetupDelegate {
        public void success(BaseApiResponseModel response);
        public void error(String response);
    }

    public interface MeetupService {
        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/get_all")
        Call<ListAllMeetupsModel> listAllMeetups(@Field("roomId") int roomId,
                                               @Field("publicKey") String publicKey,
                                               @Field("encryptedSession") String encryptedSession,
                                               @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/get_all_by_email")
        Call<ListAllMeetupsModel> listAllMeetups(@Field("email") String email,
                                                 @Field("publicKey") String publicKey,
                                                 @Field("encryptedSession") String encryptedSession,
                                                 @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/add_by_email")
        Call<CreateMeetupModel> add(@Field("email") String email,
                                         @Field("title") String title,
                                         @Field("subtitle") String subtitle,
                                         @Field("roomId") int roomId,
                                         @Field("longitude") float longitude,
                                         @Field("latitude") float latitude,
                                         @Field("isGlobal") int isGlobal,
                                         @Field("publicKey") String publicKey,
                                         @Field("encryptedSession") String encryptedSession,
                                         @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/add_by_email")
        Call<CreateMeetupModel> add(@Field("email") String email,
                                       @Field("title") String title,
                                       @Field("subtitle") String subtitle,
                                       @Field("roomId") int roomId,
                                       @Field("longitude") float longitude,
                                       @Field("latitude") float latitude,
                                       @Field("isGlobal") int isGlobal,
                                       @Field("metadata") JSONObject metadata,
                                       @Field("publicKey") String publicKey,
                                       @Field("encryptedSession") String encryptedSession,
                                       @Field("sessionHash") String sessionHash);


        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/update_by_id")
        Call<BaseApiResponseModel> update(@Field("meetupId") int meetupId,
                                    @Field("longitude") float longitude,
                                    @Field("latitude") float latitude,
                                    @Field("metadata") JSONObject metadata,
                                    @Field("publicKey") String publicKey,
                                    @Field("encryptedSession") String encryptedSession,
                                    @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/update_by_id")
        Call<BaseApiResponseModel> update(@Field("meetupId") int meetupId,
                                       @Field("longitude") float longitude,
                                       @Field("latitude") float latitude,
                                       @Field("publicKey") String publicKey,
                                       @Field("encryptedSession") String encryptedSession,
                                       @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/meetup/disable")
        Call<BaseApiResponseModel> disable(@Field("meetupId") int meetupId,
                                          @Field("publicKey") String publicKey,
                                          @Field("encryptedSession") String encryptedSession,
                                          @Field("sessionHash") String sessionHash);

    }


    public static void disable(int meetupId, final MeetupDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<BaseApiResponseModel> myCall = api.disable(meetupId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<BaseApiResponseModel>() {

            @Override
            public void onResponse(Response<BaseApiResponseModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void update(int meetupId, float longitude, float latitude,  JSONObject metadata, final MeetupDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<BaseApiResponseModel> myCall = api.update(meetupId, longitude, latitude, metadata, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<BaseApiResponseModel>() {

            @Override
            public void onResponse(Response<BaseApiResponseModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void update(int meetupId, float longitude, float latitude, final MeetupDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<BaseApiResponseModel> myCall = api.update(meetupId, longitude, latitude, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<BaseApiResponseModel>() {

            @Override
            public void onResponse(Response<BaseApiResponseModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void add(String email, String title, String subtitle, int roomId,
                           float longitude, float latitude,  int isGlobal, JSONObject metadata, final AddMeetupDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<CreateMeetupModel> myCall = api.add(email, title, subtitle, roomId, longitude, latitude,
                isGlobal, metadata, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateMeetupModel>() {

            @Override
            public void onResponse(Response<CreateMeetupModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void add(String email, String title, String subtitle, int roomId,
                float longitude, float latitude,  int isGlobal, final AddMeetupDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<CreateMeetupModel> myCall = api.add(email, title, subtitle, roomId, longitude, latitude,
                isGlobal, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateMeetupModel>() {

            @Override
            public void onResponse(Response<CreateMeetupModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


    public static void listAllMeetups(int roomId, final ListAllMeetupsDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<ListAllMeetupsModel> myCall = api.listAllMeetups(roomId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllMeetupsModel>() {

            @Override
            public void onResponse(Response<ListAllMeetupsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


    public static void listAllMeetups(String email, final ListAllMeetupsDelegate delegate){

        MeetupService api = ApiClientHelper.getRetroFit().create(MeetupService.class);
        Call<ListAllMeetupsModel> myCall = api.listAllMeetups(email, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllMeetupsModel>() {

            @Override
            public void onResponse(Response<ListAllMeetupsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

}
