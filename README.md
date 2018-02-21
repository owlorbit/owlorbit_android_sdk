# Official Owlorbit Android SDK


For the documentation on all the end-points, please visit: https://github.com/owlorbit/api



**Gradle Installation**

Add the jcenter repository to your project:

```
repositories {
    jcenter()
}
```

Then add the dependency:

```
dependencies {
    compile 'com.dinomitesoft.owlorbit.owlorbitsdk:owlorbit-sdk:1.0.+'
}
```

**Implementation**

Initialize `Owlorbit` SDK (To get your API tokens, please create a domain and navigate to https://app.owlorbit.com/account/api):

`Owlorbit owlorbit = new Owlorbit(context, publicKey, encryptedSession, sessionHash);`

Then call the API:

```
owlorbit.getApi().listAllRoomsByEmail("email@example.com", new RoomApi.ListAllRoomsDelegate() {
    @Override
    public void success(ListAllRoomModel response) {
      ...
    }

    @Override
    public void error(String response) {
      ...
    }
});
```
