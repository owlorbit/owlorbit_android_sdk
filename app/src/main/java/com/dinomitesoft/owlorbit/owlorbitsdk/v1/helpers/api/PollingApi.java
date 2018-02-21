package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.BaseApiResponseModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.CreatePollModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllGroupsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllPollChoicesModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllPollsModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListMessageTemplateModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListPollingResponsesModel;

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
 * Created by timnuwin1 on 2/5/18.
 */

public class PollingApi {

    public interface ListAllPollsDelegate {
        public void success(ListAllPollsModel response);
        public void error(String response);
    }

    public interface ListAllPollChoicesDelegate {
        public void success(ListAllPollChoicesModel response);
        public void error(String response);
    }

    public interface ListPollResponsesDelegate {
        public void success(ListPollingResponsesModel response);
        public void error(String response);
    }

    public interface CreatePollDelegate {
        public void success(CreatePollModel response);
        public void error(String response);
    }

    public interface SendPollDelegate {
        public void success(BaseApiResponseModel response);
        public void error(String response);
    }

    public interface PollingService {
        @FormUrlEncoded
        @POST(API_VERSION + "/polling/get_all_running")
        Call<ListAllPollsModel> listRunning(@Field("publicKey") String publicKey,
                                               @Field("encryptedSession") String encryptedSession,
                                               @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/polling/get_choices_by_id")
        Call<ListAllPollChoicesModel> listPollingChoices(@Field("pollingId") int pollingId,
                                                   @Field("publicKey") String publicKey,
                                                   @Field("encryptedSession") String encryptedSession,
                                                   @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/polling/get_responses")
        Call<ListPollingResponsesModel> listResponses(@Field("pollingChoiceId") int pollingChoiceId,
                                                         @Field("publicKey") String publicKey,
                                                         @Field("encryptedSession") String encryptedSession,
                                                         @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/polling/create")
        Call<CreatePollModel> create(@Field("choices[]") ArrayList<String> choices,
                                                      @Field("question") String question,
                                                      @Field("groupId") int groupId,
                                                      @Field("manualLocationEnabled") int manualLocationEnabled,
                                                      @Field("publicKey") String publicKey,
                                                      @Field("encryptedSession") String encryptedSession,
                                                      @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/polling/create")
        Call<CreatePollModel> create(@Field("choices[]") ArrayList<String> choices,
                                               @Field("question") String question,
                                               @Field("manualLocationEnabled") int manualLocationEnabled,
                                               @Field("publicKey") String publicKey,
                                               @Field("encryptedSession") String encryptedSession,
                                               @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/polling/submit_choice")
        Call<BaseApiResponseModel> submitChoice(@Field("pollingId") int pollingId,
                                                @Field("email") String email,
                                                @Field("choiceId") int choiceId,
                                                @Field("publicKey") String publicKey,
                                                @Field("encryptedSession") String encryptedSession,
                                                @Field("sessionHash") String sessionHash);
    }

    public static void submitPollChoice(int pollingId, String email, int choiceId, final SendPollDelegate delegate){
        PollingService api = ApiClientHelper.getRetroFit().create(PollingService.class);
        Call<BaseApiResponseModel> myCall = api.submitChoice(pollingId, email, choiceId, ApiSharedHelper.getInstance().getPublicKey(),
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


    public static void create(ArrayList<String> choices, String question, int groupId, int manualLocationEnabled, final CreatePollDelegate delegate){
        PollingService api = ApiClientHelper.getRetroFit().create(PollingService.class);
        Call<CreatePollModel> myCall = api.create(choices, question, groupId, manualLocationEnabled, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreatePollModel>() {

            @Override
            public void onResponse(Response<CreatePollModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void create(ArrayList<String> choices, String question, int manualLocationEnabled, final CreatePollDelegate delegate){
        PollingService api = ApiClientHelper.getRetroFit().create(PollingService.class);
        Call<CreatePollModel> myCall = api.create(choices, question, manualLocationEnabled, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<CreatePollModel>() {

            @Override
            public void onResponse(Response<CreatePollModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listPollingResponses(int pollingChoiceId, final ListPollResponsesDelegate delegate){
        PollingService api = ApiClientHelper.getRetroFit().create(PollingService.class);
        Call<ListPollingResponsesModel> myCall = api.listResponses(pollingChoiceId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListPollingResponsesModel>() {

            @Override
            public void onResponse(Response<ListPollingResponsesModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listPollingChoices(int pollingId, final ListAllPollChoicesDelegate delegate){
        PollingService api = ApiClientHelper.getRetroFit().create(PollingService.class);
        Call<ListAllPollChoicesModel> myCall = api.listPollingChoices(pollingId, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllPollChoicesModel>() {

            @Override
            public void onResponse(Response<ListAllPollChoicesModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void listRunning(final ListAllPollsDelegate delegate){
        PollingService api = ApiClientHelper.getRetroFit().create(PollingService.class);
        Call<ListAllPollsModel> myCall = api.listRunning(ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllPollsModel>() {

            @Override
            public void onResponse(Response<ListAllPollsModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

}
