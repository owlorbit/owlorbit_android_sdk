package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreateGroupModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllGroupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllRoomModel;

import java.util.ArrayList;

import retrofit.Call;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.POST;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;

import static com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.CommonResource.API_VERSION;

/**
 * Created by timnuwin1 on 2/1/18.
 */

public class GroupApi {

    public interface ListAllGroupsDelegate {
        public void success(ListAllGroupsModel response);
        public void error(String response);
    }

    public interface CreateGroupDelegate {
        public void success(CreateGroupModel response);
        public void error(String response);
    }

    public interface UpdateGroupDelegate {
        public void success(BaseApiResponseModel response);
        public void error(String response);
    }


    public interface GroupService {
        @FormUrlEncoded
        @POST(API_VERSION + "/group/all")
        Call<ListAllGroupsModel> listAllGroups(@Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);


        @FormUrlEncoded
        @POST(API_VERSION + "/group/add")
        Call<CreateGroupModel> create(@Field("usersAdded[]") ArrayList<Integer> usersAdded,
                                   @Field("groupName") String groupName,
                                   @Field("publicKey") String publicKey,
                                   @Field("encryptedSession") String encryptedSession,
                                   @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/group/update")
        Call<BaseApiResponseModel> update(@Field("groupId") int groupId,
                                      @Field("usersAdded[]") ArrayList<Integer> usersAdded,
                                      @Field("publicKey") String publicKey,
                                      @Field("encryptedSession") String encryptedSession,
                                      @Field("sessionHash") String sessionHash);
    }

    public static void update(int groupId, ArrayList<Integer> usersAdded, final UpdateGroupDelegate delegate){

        GroupService api = ApiClientHelper.getRetroFit().create(GroupService.class);
        Call<BaseApiResponseModel> myCall = api.update(groupId, usersAdded, ApiSharedHelper.getInstance().getPublicKey(),
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


    public static void create(ArrayList<Integer> usersAdded, String groupName, final CreateGroupDelegate delegate){

        GroupService api = ApiClientHelper.getRetroFit().create(GroupService.class);
        Call<CreateGroupModel> myCall = api.create(usersAdded, groupName, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreateGroupModel>() {

            @Override
            public void onResponse(Response<CreateGroupModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listAllGroups(final ListAllGroupsDelegate delegate){

        GroupService api = ApiClientHelper.getRetroFit().create(GroupService.class);
        Call<ListAllGroupsModel> myCall = api.listAllGroups(ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllGroupsModel>() {

            @Override
            public void onResponse(Response<ListAllGroupsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


}
