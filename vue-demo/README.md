# LooStudyFoo

### 为什么要开发

最近在练习快捷键，找到[ShortcutFoo](https://www.shortcutfoo.com/app)，进行练习，发现体验糟糕透了

1. 国内访问卡顿厉害，用SS都没用
2. 前2章节免费，之后所有章节都要收费，包月需要8刀
3. 没有数据分析，只有成就(有毛用)，根据数据进行专项训练很重要
4. 觉得章节不合理，或者与你自己惯用快捷键不符不能进行调整，为了过关完下一章，只能硬着头皮练习个别错误的快捷键(硬伤)
5. 本身网站技术含量不高，与收费不成正比
6. 网站本身设置的章节内容是可以查看的，只是没法操作练习
7. 找不到其他网站可以代替它

综上所述，由于最近正好在学vue，决定用vue做一个简单可用的快捷键训练工具，章节从shortcutfoo获取，根据喜好定制一些数据采集与现实。

### 需求

1. 可以选择课程和章节
2. 每章都有学习，练习，测验模式
3. 每日采集数据 => 每题 => { 最快答对用时 平均答对用时 最慢答对用时 成功率 练习次数 }

### 知识梳理

```

- Vue
  - script
    - data
    - props
    - computed
    - method
      - $emit
      - $ref
    - components
    - mounted
  - template
    - v-if
    - v-for
    - ref
    - @click.native
    - @keydown.prevent *
    - transition

- JavaScript
  - event.keCode *
    - e.ctrlKey
    - e.shiftKey
    - e.altKey
    - e.metaKey
  - Math
    - floor
    - round
    - random
  - Date
    - getTime
    - getFullYear
    - getMonth
    - getDate
  - for ... in
  - input.focus() *
  - blur *
  - localStorage

- iView
  - Grid
    - Row
      - Col
        - span
  - Card
  - Table
    - :columns
      - title
      - key
      - width
      - sortable
      - fixed
      - align
      - render
    - :data
      - cellClassName
    - height
  - Menu
    - mode
    - active-name
    - @on-select
    - Menu-item
      - name
```

### 深入实践

1. 不用vue-cli尝试搭建工程项目
2. 加入vuex提供全局状态维护
3. vue-router使用
4. 探究如何使用完整es6语法功能

### 待开发功能
1. 多元化数据分析，每日总表，单题Chart曲线
2. 国际化规范
3. 测验模式，随机20题，2秒 5秒 8秒 3挡时间选择 测试通过给出成绩，测试也练习模式分开统计
4. 修改配置文件格式，key的值作为object的key

### 开发日志

#### 2017/4/26
1. 确定配置文件结构
2. 题目章节导航
3. 章节练习模式实现

#### 2017/4/27
1. 使用iView优化UI排版
2. 组件化代码
3. 点击开始焦点绑定input

#### 2017/4/28
1. 添加简单动画
2. 添加学习模式
3. 练习模式和测验模式包含之前章节
4. 显示每次完成快捷键的时间
5. 配置文件增加key值，每个题key唯一
6. 按日期记录每天的练习成绩，维护到localStorage

#### 2017/4/29
1. 添加数据分析总表
