package com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers;

/**
 * Created by timnuwin1 on 1/29/18.
 */

public class ApiSharedHelper {

    private static ApiSharedHelper mInstance = null;
    private boolean prefAlwaysOn;

    private String publicKey;
    private String encryptedSession;
    private String sessionHash;


    private ApiSharedHelper() {
    }

    public static ApiSharedHelper getInstance(){
        if(mInstance == null) {
            mInstance = new ApiSharedHelper();
        }
        return mInstance;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getSessionHash() {
        return sessionHash;
    }

    public void setSessionHash(String sessionHash) {
        this.sessionHash = sessionHash;
    }

    public String getEncryptedSession() {
        return encryptedSession;
    }

    public void setEncryptedSession(String encryptedSession) {
        this.encryptedSession = encryptedSession;
    }
}
