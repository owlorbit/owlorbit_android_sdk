package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllLocationsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllRoomModel;

import org.json.JSONObject;

import retrofit.Call;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.POST;
import retrofit.Call;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;

import static com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.CommonResource.API_VERSION;


/**
 * Created by timnuwin1 on 1/31/18.
 */

public class LocationApi {

    public interface ListAllLocationsDelegate {
        public void success(ListAllLocationsModel response);
        public void error(String response);
    }

    public interface AddLocationsDelegate {
        public void success(BaseApiResponseModel response);
        public void error(String response);
    }

    public interface LocationService {
        @FormUrlEncoded
        @POST(API_VERSION + "/location/get_all_user_locations")
        Call<ListAllLocationsModel> listAllLocations(@Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);


        @FormUrlEncoded
        @POST(API_VERSION + "/location/user_location_by_email")
        Call<ListAllLocationsModel> listAllLocations(@Field("email") String email,
                                            @Field("publicKey") String publicKey,
                                             @Field("encryptedSession") String encryptedSession,
                                             @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/location/get_locations_by_room_id")
        Call<ListAllLocationsModel> listAllLocationsByRoomId(@Field("roomId") int roomId,
                                                     @Field("publicKey") String publicKey,
                                                     @Field("encryptedSession") String encryptedSession,
                                                     @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/location/add_by_user_email")
        Call<BaseApiResponseModel> add(@Field("email") String email,
                                        @Field("longitude") double longitude,
                                        @Field("latitude") double latitude,
                                     @Field("publicKey") String publicKey,
                                     @Field("encryptedSession") String encryptedSession,
                                     @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/location/add_by_user_email")
        Call<BaseApiResponseModel> add(@Field("email") String email,
                                       @Field("longitude") double longitude,
                                       @Field("latitude") double latitude,
                                       @Field("metadata")JSONObject metadata,
                                       @Field("publicKey") String publicKey,
                                       @Field("encryptedSession") String encryptedSession,
                                       @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/location/add_by_user_email")
        Call<BaseApiResponseModel> add(@Field("email") String email,
                                       @Field("longitude") double longitude,
                                       @Field("latitude") double latitude,
                                       @Field("altitude") double altitude,
                                       @Field("publicKey") String publicKey,
                                       @Field("encryptedSession") String encryptedSession,
                                       @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/location/add_by_user_email")
        Call<BaseApiResponseModel> add(@Field("email") String email,
                                       @Field("longitude") double longitude,
                                       @Field("latitude") double latitude,
                                       @Field("altitude") double altitude,
                                       @Field("metadata")JSONObject metadata,
                                       @Field("publicKey") String publicKey,
                                       @Field("encryptedSession") String encryptedSession,
                                       @Field("sessionHash") String sessionHash);
    }

    public static void add(String email, double longitude, double latitude, double altitude, JSONObject metadata, final AddLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<BaseApiResponseModel> myCall = api.add(email, longitude, latitude, altitude, metadata, ApiSharedHelper.getInstance().getPublicKey(),
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

    public static void add(String email, double longitude, double latitude, JSONObject metadata, final AddLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<BaseApiResponseModel> myCall = api.add(email, longitude, latitude, metadata, ApiSharedHelper.getInstance().getPublicKey(),
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

    public static void add(String email, double longitude, double latitude, double altitude, final AddLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<BaseApiResponseModel> myCall = api.add(email, longitude, latitude, altitude, ApiSharedHelper.getInstance().getPublicKey(),
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


    public static void add(String email, double longitude, double latitude, final AddLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<BaseApiResponseModel> myCall = api.add(email, longitude, latitude, ApiSharedHelper.getInstance().getPublicKey(),
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


    public static void listAllLocationsByRoomId(int roomId, final ListAllLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<ListAllLocationsModel> myCall = api.listAllLocationsByRoomId(roomId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllLocationsModel>() {

            @Override
            public void onResponse(Response<ListAllLocationsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listAllLocations(String email, final ListAllLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<ListAllLocationsModel> myCall = api.listAllLocations(email, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllLocationsModel>() {

            @Override
            public void onResponse(Response<ListAllLocationsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listAllLocations(final ListAllLocationsDelegate delegate){

        LocationService api = ApiClientHelper.getRetroFit().create(LocationService.class);
        Call<ListAllLocationsModel> myCall = api.listAllLocations(ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllLocationsModel>() {

            @Override
            public void onResponse(Response<ListAllLocationsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

}