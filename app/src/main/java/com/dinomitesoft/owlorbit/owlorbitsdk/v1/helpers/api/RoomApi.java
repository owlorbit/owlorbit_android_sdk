package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateRoomModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllRoomModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllUserModel;

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
 * Created by timnuwin1 on 1/30/18.
 */

public class RoomApi {

    public interface ListAllRoomsDelegate {
        public void success(ListAllRoomModel response);
        public void error(String response);
    }

    public interface JoinRoomDelegate {
        public void success(BaseApiResponseModel response);
        public void error(String response);
    }

    public interface CreateRoomDelegate {
        public void success(CreateRoomModel response);
        public void error(String response);
    }

    public interface RoomService {
        @FormUrlEncoded
        @POST(API_VERSION + "/room/get_rooms_in_domain")
        Call<ListAllRoomModel> listAllRooms(@Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/room/get_rooms_by_email")
        Call<ListAllRoomModel> listAllRooms(@Field("email") String email,
                                            @Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/room/join_room_by_email")
        Call<BaseApiResponseModel> joinRoom(@Field("roomId") int roomId,
                                            @Field("email") String email,
                                            @Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/room/create")
        Call<CreateRoomModel> create(@Field("userIds[]") ArrayList<Integer> userIds,
                                     @Field("email") String email,
                                     @Field("name") String name,
                                     @Field("isFriendsOnly") int isFriendsOnly,
                                     @Field("isPublic") int isPublic,
                                     @Field("publicKey") String publicKey,
                                     @Field("encryptedSession") String encryptedSession,
                                     @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/room/create")
        Call<CreateRoomModel> create(@Field("userIds[]") ArrayList<Integer> userIds,
                                     @Field("email") String email,
                                     @Field("name") String name,
                                     @Field("isFriendsOnly") int isFriendsOnly,
                                     @Field("isPublic") int isPublic,
                                     @Field("messageTemplateId") int messageTemplateId,
                                     @Field("publicKey") String publicKey,
                                     @Field("encryptedSession") String encryptedSession,
                                     @Field("sessionHash") String sessionHash);

    }

    public static void createRoom(ArrayList<Integer> userIds,
                                  String email,
                                  String name,
                                  int isFriendsOnly,
                                  int isPublic,
                                  final CreateRoomDelegate delegate){

        RoomService api = ApiClientHelper.getRetroFit().create(RoomService.class);
        Call<CreateRoomModel> myCall = api.create(userIds, email, name, isFriendsOnly, isPublic, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateRoomModel>() {

            @Override
            public void onResponse(Response<CreateRoomModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void createRoom(ArrayList<Integer> userIds,
                                  String email,
                                  String name,
                                  int isFriendsOnly,
                                  int isPublic,
                                  int messageTemplateId, final CreateRoomDelegate delegate){

        RoomService api = ApiClientHelper.getRetroFit().create(RoomService.class);
        Call<CreateRoomModel> myCall = api.create(userIds, email, name, isFriendsOnly, isPublic, messageTemplateId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateRoomModel>() {

            @Override
            public void onResponse(Response<CreateRoomModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void joinRoom(int roomId, String email, final JoinRoomDelegate delegate){

        RoomService api = ApiClientHelper.getRetroFit().create(RoomService.class);
        Call<BaseApiResponseModel> myCall = api.joinRoom(roomId, email, ApiSharedHelper.getInstance().getPublicKey(),
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

    public static void listAllRooms(final ListAllRoomsDelegate delegate){

        RoomService api = ApiClientHelper.getRetroFit().create(RoomService.class);
        Call<ListAllRoomModel> myCall = api.listAllRooms(ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllRoomModel>() {

            @Override
            public void onResponse(Response<ListAllRoomModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listAllRooms(String email, final ListAllRoomsDelegate delegate){

        RoomService api = ApiClientHelper.getRetroFit().create(RoomService.class);
        Call<ListAllRoomModel> myCall = api.listAllRooms(email, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllRoomModel>() {

            @Override
            public void onResponse(Response<ListAllRoomModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }
}
