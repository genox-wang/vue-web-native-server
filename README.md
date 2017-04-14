# Vue-Web-Native-Server开发

[Demo源码](https://coding.net/u/loostudy/p/vue-web-native-server/git) 

---

排坑过程中找到一个不错的项目https://github.com/wangwei123/weex-vue，自己搭建的命令行实现一键部署的功能，以后需要整合的时候可以借鉴

---

## Weex开发

### 工作原理

这里盗张Weex官方文档的图

<a href="http://weex.apache.org/cn/guide/intro/how-it-works.html" ><img src = "http://weex.apache.org/cn/guide/images/flow.png" width="900"></a>

由原理图，我们分三块来学习Weex

- 如何把Vue打包成JSBundle
- Android平台如何用JSBundle
- IOS平台如何使用JSBundle

### 如何把Vue打包成JSBundle

### 安装toolkit

```

npm install -g weex-toolkit

```

### 新建项目

```
$ weex init weex-demo

```

### 运行项目

```
cd weex-demo

npm run dev

npm run serve

```

在`http://localhost:8080/index.html`查看

---

注意：当前版本需要对`weex.html`做如下修改才能正常运行，要不会找不到`index.js`

```html
<!-- 官方的 -->
<!-- <script src="./node_modules/weex-vue-render/index.js"></script> -->
<!-- 修改后的 -->
<script src="./node_modules/weex-vue-render/dist/index.js"></script>

```

---


### 打包**.vue**文件

```

weex compile src/foo.vue dist

```
运行完就会在dist文件夹下找到编译完的foo.js，**这个就是打包好的JSBundle**


### Android平台如何用JSBundle

参考[Weex-Android开发](https://coding.net/u/loostudy/p/vue-web-native-server/git/tree/master/weex-android-demo)

### IOS平台如何用JSBundle

参考[Weex-IOS开发](https://coding.net/u/loostudy/p/vue-web-native-server/git/tree/master/weex-ios-demo)

## 参考

* [搭建Weex开发环境](http://weex.apache.org/cn/guide/set-up-env.html)
* [使用 weex-toolkit](http://weex.apache.org/cn/guide/tools/toolkit.html)