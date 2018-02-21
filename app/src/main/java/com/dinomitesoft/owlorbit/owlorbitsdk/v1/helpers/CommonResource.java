package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers;

/**
 * Created by timnuwin1 on 1/26/18.
 */

public class CommonResource {

    public final static String API_VERSION = "/v1";
    public static boolean IS_PRODUCTION = true;
    public static String BASE_URL = (IS_PRODUCTION ) ? "https://api.owlorbit.com/" : "http://192.168.99.100:8080/";

    public static boolean NETWORK_LOGGING = false;
    public static boolean DETAILED_NETWORK_LOGGING = false;
}
