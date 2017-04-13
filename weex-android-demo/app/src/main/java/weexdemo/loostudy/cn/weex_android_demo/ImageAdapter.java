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
