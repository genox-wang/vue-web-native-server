# Weex-Android开发


- [工程源码](https://coding.net/u/loostudy/p/vue-web-native-server/git/tree/master/weex-android-demo)
- [WeexSDK最新版本jcenter](https://bintray.com/alibabaweex/maven/weex_sdk/view)

## 准备

- AndroidStudio
- JDK version>=1.7
- Android SDK version 23
- Android SDK build tools version 23.0.1
- Android Support Repository >= 17

## 脚手架搭建

### 创建新项目

使用AndroidStudio创建新项目

### gradle配置

```
apply plugin: 'com.android.application'

android {

        ......

        /**
         * 必须加，否则64位手机无法加载so文件
         */
        ndk {
            abiFilters "x86"
            abiFilters "armeabi"
        }
    }

    ......

}

dependencies {
        ......

    compile 'com.android.support:appcompat-v7:24.2.1'
    compile 'com.android.support:recyclerview-v7:24.1.1'
    compile 'com.android.support:support-v4:24.1.1'
    compile 'com.android.support:appcompat-v7:24.1.1'
     //https://bintray.com/alibabaweex/maven/weex_sdk/view可以查看最新版本，尽量用最新的,0.9.5以下无法加载vue，血的教训
    compile 'com.taobao.android:weex_sdk:0.11.0'
    compile 'com.alibaba:fastjson:1.1.56.android'//json解析
    compile 'com.github.bumptech.glide:glide:3.7.0'//图片加载插件
    ....
}

```

### 代码实现

- 实现图片下载接口，初始化时设置。

```java

package weexdemo.loostudy.cn.weex_android_demo;

import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.taobao.weex.adapter.IWXImgLoaderAdapter;
import com.taobao.weex.common.WXImageStrategy;
import com.taobao.weex.dom.WXImageQuality;

/**
 * Created by bill on 2017/4/13.
 */

public class ImageAdapter implements IWXImgLoaderAdapter {

    @Override
    public void setImage(String url, ImageView view, WXImageQuality quality, WXImageStrategy strategy) {
        //实现自己的图片的下载，否则图片无法下载
        //图片加载用glide实现 https://github.com/bumptech/glide
        Glide.with(view.getContext())
                .load(url)
                .into(view);
    }
}

```

- 初始化

```java
package weexdemo.loostudy.cn.weex_android_demo;

import android.app.Application;

import com.taobao.weex.InitConfig;
import com.taobao.weex.WXSDKEngine;

/**
 * Created by bill on 2017/4/13.
 */

/**
 * 注意要在Manifest中设置android:name=".WXApplication"
 * 要实现ImageAdapter 否则图片不能下载
 * gradle 中一定要添加一些依赖，否则初始化会失败。
 */

public class WXApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        InitConfig config = new InitConfig.Builder().setImgAdapter(new ImageAdapter()).build();
        WXSDKEngine.initialize(this,config);
    }
}

```

- 渲染

```java
package weexdemo.loostudy.cn.weex_android_demo;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

import com.taobao.weex.IWXRenderListener;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.common.WXRenderStrategy;
import com.taobao.weex.utils.WXFileUtils;

public class IndexActivity extends AppCompatActivity implements IWXRenderListener{

    WXSDKInstance mWXSDKInstance;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_index);

        mWXSDKInstance = new WXSDKInstance(this);
        mWXSDKInstance.registerRenderListener(this);

        /**
         * pageName 可以替换成自定义的字符串，针对埋点有效。
         * template 是.we transform 后的 js文件。
         * option 可以为空，或者通过option传入 js需要的参数。例如bundle js的地址等。
         * jsonInitData 可以为空。
         * flag:渲染策略。WXRenderStrategy.APPEND_ASYNC:异步策略先返回外层View，其他View渲染完成后调用onRenderSuccess。WXRenderStrategy.APPEND_ONCE 所有控件渲染完后后一次性返回。
         */
//        mWXSDKInstance.render("localPage", WXFileUtils.loadAsset("foo.js", this), null, null, WXRenderStrategy.APPEND_ASYNC);

        mWXSDKInstance.renderByUrl("urlPage", "http://www.happygod.cn/foo.js", null, null, WXRenderStrategy.APPEND_ASYNC);
    }

    @Override
    public void onViewCreated(WXSDKInstance instance, View view) {
        setContentView(view);
    }

    @Override
    public void onRenderSuccess(WXSDKInstance instance, int width, int height) {

    }

    @Override
    public void onRefreshSuccess(WXSDKInstance instance, int width, int height) {

    }

    @Override
    public void onException(WXSDKInstance instance, String errCode, String msg) {

    }

    @Override
    protected void onResume() {
        super.onResume();
        if(mWXSDKInstance!= null) {
            mWXSDKInstance.onActivityResume();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if(mWXSDKInstance!= null) {
            mWXSDKInstance.onActivityPause();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if(mWXSDKInstance!=null) {
            mWXSDKInstance.onActivityStop();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(mWXSDKInstance!= null) {
            mWXSDKInstance.onActivityDestroy();
        }
    }
}

```

Manifest添加网络权限

```
<uses-permission android:name="android.permission.INTERNET"></uses-permission>
```

### 添加本地资源

在`app/src/main`目录下创建`assets`文件夹，里面放入打包好的`foo.js`

### 搭建完成

到此开发脚手架已经搭建完成！连接手机就可以运行调试，在Weex开发页面，打包完在渲染Activity里加渲染就可以看到效果。

## 参考

- [WEEX SDK集成到工程](https://github.com/weexteam/article/issues/25)