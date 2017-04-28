<template>
  <div>
    <Row>
      <Col span="3">
        <Card class="back-box" @click.native="back">
          <Icon type="chevron-left" size="20"></Icon>
        </Card>
      </Col>
      <Col span="18">
        <div class="title">
          <h2>{{ chapter_name }}</h2>
        </div>
      </Col>
    </Row>
    <Row>
      <Col span="8"><Card class="menu-box" style="background: #86D9FB; color: white;" @click.native="learn"><h2>Learn</h2></Card></Col>
      <Col span="8"><Card class="menu-box" style="background: #41B883;; color: white;" @click.native="practice"><h2>Practice</h2></Card></Col>
      <Col span="8"><Card class="menu-box" style="background: #F3625D; color: white;" @click.native="test"><h2>Test</h2></Card></Col>
    </Row>
    <input ref="input" style="height: 0"  @keydown="onKeyDown" @blur="onBlur" readonly="true">
    <Card class="menu-box">
      <Row>
        <Col span="4" style="text-align: left; padding-left: 20px"><h2>Question:</h2></Col>
        <Col span="16"><h2 v-if="current_item !== undefined">{{ current_item.question }}</h2></Col>
        <Col v-if="isLearn" span="4" style="text-align: right;padding-top: 5px;padding-right: 20px"><h3 v-if="current_item !== undefined">{{ current_item.answer }}</h3></Col>
      </Row>
    </Card>
    <transition-group name="pop" leave-active-class="pop-leave-active">
      <Card v-for=" h in history" class="menu-box" :key="h.index">
        <Row>
          <Col span="12" style="text-align: left; padding-left: 20px"><h3>{{ h.question }}</h3></Col>
          <Col span="4" style="text-align: left;"><h3 :class="h.shortcutClass">{{ h.myshortcut }}</h3></Col>
          <Col span="4" style="text-align: left;padding-left: 20px"><h3>{{ h.answer }}</h3></Col>
          <Col span="4" style="text-align: right;padding-right: 20px"><h3 :class="h.timeClass">{{ h.time }}</h3></Col>
        </Row>
      </Card>
    </transition-group>
  </div>
</template>

<script>
let keycodes = require('../conf/keycodes.json')
const statsNone = 0
const statsLearn = 1
const statsPractice = 2
const statsTest = 3
export default {
  name: 'LearnAndPractice',
  data () {
    return {
      myshortcut: '',          // 我的操作
      current_item: undefined, // 当前题目
      history: [],             // 操作历史
      historyIndex: 0,         // 用来标示历史记录的唯一ID
      stats: statsNone,        // 状态维护
      learnIndex: 0,           // 学习的到位置
      startTime: 0             // 计时开始
    }
  },
  props: [
    'current_items',
    'chapter_name',
    'items2current'
  ],
  computed: {
    isLearn: function () {
      return this.stats === statsLearn
    }
  },
  methods: {
    saveStorage: function (key, json) {
      window.localStorage.setItem(key, JSON.stringify(json))
    },
    loadStorage: function (key) {
      return JSON.parse(window.localStorage.getItem(key))
    },
    save: function (item, time, isCurrent) {
      if (this.isLearn) {
        return
      }
      let data = this.loadStorage(item.key) || {}
      let date = new Date()
      let formatDate = date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
      if (data[formatDate] === undefined) data[formatDate] = { times: 0, currect: 0 }
      let dataToday = data[formatDate]
      if (isCurrent) {
        let fastest = dataToday.fastest || 999999
        let avg = dataToday.avg || 0
        let slowest = dataToday.slowest || 0
        fastest = Math.min(fastest, time)
        slowest = Math.max(slowest, time)
        avg = (avg * dataToday.currect + time) / (dataToday.currect + 1)
        dataToday.fastest = fastest
        dataToday.avg = Math.round(avg)
        dataToday.slowest = slowest
        dataToday.currect ++
      }
      dataToday.times ++
      this.saveStorage(item.key, data)
    },
    back: function () {
      this.$emit('back')
    },
    practice: function () {
      this.start(statsPractice)
    },
    learn: function () {
      this.start(statsLearn)
    },
    test: function () {
      this.start(statsTest)
    },
    randomItem: function () {
      let rand = -1
      do {
        rand = Math.floor(Math.random() * this.current_items.length)
      } while (this.current_item === this.current_items[rand])
      return this.current_items[rand]
    },
    start: function (stats) {
      this.history = []
      this.historyIndex = 0
      this.stats = stats
      this.$refs.input.focus()
      this.next()
    },
    next: function () {
      this.startTime = new Date().getTime()
      switch (this.stats) {
        case statsLearn:
          this.current_item = this.current_items[this.learnIndex++]
          this.learnIndex = this.learnIndex % this.current_items.length
          break
        case statsPractice:
        case statsTest:
          this.current_item = this.randomItem()
          break
        default:
      }
    },
    compareShortcuts: function (s1, s2) {
      let i
      for (i = 0; i < s1.length; i++) {
        if (!s2.includes(s1[i])) { return false }
      }
      for (i = 0; i < s2.length; i++) {
        if (!s1.includes(s2[i])) { return false }
      }
      return true
    },
    onBlur: function () {
      // console.log('bbb')
      if (this.$refs.input) {
        this.$refs.input.focus()
      }
    },
    onKeyDown: function (e) {
      // console.log(e.keyCode)
      e.preventDefault()
      if (this.stats === statsNone) { // 没有开始练习不能进行操作
        return
      }
      let myshortcut = this.myshortcut
      if (e.ctrlKey) {
        myshortcut += '⌃'
      }
      if (e.shiftKey) {
        myshortcut += '⇧'
      }
      if (e.altKey) {
        myshortcut += '⌥'
      }
      if (e.metaKey) {
        myshortcut += '⌘'
      }
      let _key = keycodes[e.keyCode]
      if (_key !== undefined) {
        let costTime = new Date().getTime() - this.startTime
        myshortcut += _key
        if (!this.current_item.answer.includes(' ') || myshortcut.includes(' ')) {
          this.myshortcut = ''
          if (this.history.length > 3) {
            this.history.pop()
          }
          let s = Math.floor(costTime / 1000)
          let ms = Math.round((costTime % 1000) / 10)
          let timeClass = 'speed-fast'
          if (costTime >= 10000) {
            timeClass = 'speed-slow'
          } else if (costTime >= 2000) {
            timeClass = 'speed-mid'
          }
          let isCurrent = this.compareShortcuts(this.current_item.answer, myshortcut)
          this.history.unshift({
            key: this.current_item.key,
            index: this.historyIndex++,
            question: this.current_item.question,
            answer: this.current_item.answer,
            myshortcut: myshortcut,
            shortcutClass: isCurrent ? 'currect' : 'error',
            time: s + '\'' + ms + '"',
            timeClass: timeClass
          })
          this.save(this.current_item, costTime, isCurrent)
          this.next()
        } else {
          this.myshortcut = myshortcut + ' '
        }
      }
    }
  }
}
</script>
