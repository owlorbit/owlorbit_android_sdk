package com.dinomitesoft.owlorbit.owlorbitsdk.v1;

import android.content.Context;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.OwlorbitApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.helpers.api.RoomApi;
import com.dinomitesoft.owlorbit.owlorbitsdk.v1.models.ListAllRoomModel;

/**
 * Created by timnuwin1 on 1/28/18.
 */

public class Owlorbit {
    private Context mContext;
    private OwlorbitApi mOwlorbitApi;

    public Owlorbit(Context context, String publicKey, String encryptedSession, String sessionHash) {
        mContext = context;
        mOwlorbitApi = new OwlorbitApi(context, publicKey, encryptedSession, sessionHash);
    }

    public OwlorbitApi getApi() {
        return mOwlorbitApi;
    }
}
