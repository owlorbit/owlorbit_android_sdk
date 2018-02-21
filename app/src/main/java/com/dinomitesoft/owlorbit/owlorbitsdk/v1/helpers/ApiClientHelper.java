package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers;

/**
 * Created by timnuwin1 on 1/28/18.
 */

import com.google.gson.GsonBuilder;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.logging.HttpLoggingInterceptor;

import java.util.concurrent.TimeUnit;

import retrofit.GsonConverterFactory;
import retrofit.Retrofit;

public class ApiClientHelper {

    public ApiClientHelper(){
    }

    public static retrofit.Retrofit getRetroFit(){

        OkHttpClient client = new OkHttpClient();
        if(CommonResource.NETWORK_LOGGING) {
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            if(CommonResource.DETAILED_NETWORK_LOGGING){
                interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            }else{
                interceptor.setLevel(HttpLoggingInterceptor.Level.BASIC);
            }

            client.interceptors().add(interceptor);
        }

        client.setConnectTimeout(15, TimeUnit.SECONDS);
        client.setWriteTimeout(15, TimeUnit.SECONDS);
        client.setReadTimeout(30, TimeUnit.SECONDS);

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(CommonResource.BASE_URL)
                .addConverterFactory(GsonConverterFactory.create(new GsonBuilder()
                        .excludeFieldsWithoutExposeAnnotation()
                        .create()))
                .client(client)
                .build();

        return retrofit;
    }
}
