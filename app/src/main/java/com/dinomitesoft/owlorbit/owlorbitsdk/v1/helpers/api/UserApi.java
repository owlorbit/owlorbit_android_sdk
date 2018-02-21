package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api;

import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiClientHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.ApiSharedHelper;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.AddUserDomainModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.DoesEmailExistModel;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllUserModel;

import retrofit.Call;
import retrofit.Callback;
import retrofit.Response;
import retrofit.Retrofit;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.POST;

import static com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.CommonResource.API_VERSION;

public class UserApi {

    public interface EmailExistDelegate {
        public void success(DoesEmailExistModel doesEmailExistModel);
        public void error(String response);
    }

    public interface AddUserDelegate {
        public void success(AddUserDomainModel addUserDomainModel);
        public void error(String response);
    }

    public interface ListAllUsersDelegate {
        public void success(ListAllUserModel response);
        public void error(String response);
    }

    public interface UserService {

        @FormUrlEncoded
        @POST(API_VERSION + "/user/does_email_exist")
        Call<DoesEmailExistModel> getDoesEmailExist(@Field("domain") String domain,
                                                    @Field("email") String email,
                                                    @Field("publicKey") String publicKey,
                                                    @Field("encryptedSession") String encryptedSession,
                                                    @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/user/add_user_to_domain")
        Call<AddUserDomainModel> addUserToDomain(@Field("email") String email,
                                                 @Field("password") String password,
                                                 @Field("first_name") String firstName,
                                                 @Field("last_name") String lastName,
                                                 @Field("phone_number") String phoneNumber,
                                                 @Field("publicKey") String publicKey,
                                                 @Field("encryptedSession") String encryptedSession,
                                                 @Field("sessionHash") String sessionHash);

        @FormUrlEncoded
        @POST(API_VERSION + "/user/list_all_domain_users")
        Call<ListAllUserModel> listAllUsers(@Field("publicKey") String publicKey,
                                            @Field("encryptedSession") String encryptedSession,
                                            @Field("sessionHash") String sessionHash);

    }

    public static void listAllUsers(final ListAllUsersDelegate delegate){

        UserService api = ApiClientHelper.getRetroFit().create(UserService.class);
        Call<ListAllUserModel> myCall = api.listAllUsers(ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<ListAllUserModel>() {

            @Override
            public void onResponse(Response<ListAllUserModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }


    public static void addUserToDomain(String email, String password,
                                       String firstName, String lastName,
                                       String phoneNumber, final AddUserDelegate delegate){

        if(email.length() == 0){
            delegate.error("Email is empty.");
            return;
        }

        if(password.length() == 0){
            delegate.error("Password is empty.");
            return;
        }

        if(firstName.length() == 0){
            delegate.error("First Name is empty.");
            return;
        }

        if(lastName.length() == 0){
            delegate.error("Last Name is empty.");
            return;
        }

        if(phoneNumber.length() == 0){
            delegate.error("Phone Number is empty.");
            return;
        }

        UserService api = ApiClientHelper.getRetroFit().create(UserService.class);

        Call<AddUserDomainModel> myCall = api.addUserToDomain(email, password, firstName, lastName, phoneNumber, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<AddUserDomainModel>() {

            @Override
            public void onResponse(Response<AddUserDomainModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }

    public static void doesEmailExist(String domain, String email, final EmailExistDelegate delegate){
        if(domain.length() == 0){
            delegate.error("Domain is empty.");
            return;
        }

        if(email.length() == 0){
            delegate.error("Email is empty.");
            return;
        }

        UserService api = ApiClientHelper.getRetroFit().create(UserService.class);
        Call<DoesEmailExistModel> myCall = api.getDoesEmailExist(domain, email, ApiSharedHelper.getInstance().getPublicKey(),
                ApiSharedHelper.getInstance().getEncryptedSession(), ApiSharedHelper.getInstance().getSessionHash());
        myCall.enqueue(new Callback<DoesEmailExistModel>() {

            @Override
            public void onResponse(Response<DoesEmailExistModel> response, Retrofit retrofit) {
                delegate.success(response.body());
            }

            @Override
            public void onFailure(Throwable t) {
                delegate.error(t.getMessage());
            }
        });
    }
}