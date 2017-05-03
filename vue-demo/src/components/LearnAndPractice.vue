<template>
  <div>
    <Row>
      <i-col span="3">
        <Card class="back-box" @click.native="back">
          <Icon type="chevron-left" size="20"></Icon>
        </Card>
      </i-col>
      <i-col span="18">
        <div class="title">
          <h2>{{ chapter_name }}</h2>
        </div>
      </i-col>
    </Row>
    <Row>
      <i-col span="8"><Card class="menu-box" style="background: #86D9FB; color: white;" @click.native="learn"><h2>Learn</h2></Card></i-col>
      <i-col span="8"><Card class="menu-box" style="background: #41B883;; color: white;" @click.native="practice"><h2>Practice</h2></Card></i-col>
      <i-col span="8"><Card class="menu-box" style="background: #F3625D; color: white;" @click.native="test"><h2>Test</h2></Card></i-col>
    </Row>
    <input ref="input" style="height: 0"  @keydown.prevent="onKeyDown" @blur="onBlur" readonly="true">
    <Card class="menu-box">
      <Row>
        <i-col span="4" style="text-align: left; padding-left: 20px"><h2>Question:</h2></i-col>
        <i-col span="16"><h2 v-if="current_item !== undefined">{{ current_item.question }}</h2></i-col>
        <i-col v-if="isLearn" span="4" style="text-align: right;padding-top: 5px;padding-right: 20px"><h3 v-if="current_item !== undefined">{{ current_item.answer }}</h3></i-col>
      </Row>
    </Card>
    <transition-group name="pop" leave-active-class="pop-leave-active">
      <Card v-for=" h in history" class="menu-box" :key="h.index">
        <Row>
          <i-col span="12" style="text-align: left; padding-left: 20px"><h3>{{ h.question }}</h3></i-col>
          <i-col span="4" style="text-align: left;"><h3 :class="h.shortcutClass">{{ h.myshortcut }}</h3></i-col>
          <i-col span="4" style="text-align: left;padding-left: 20px"><h3>{{ h.answer }}</h3></i-col>
          <i-col span="4" style="text-align: right;padding-right: 20px"><h3 :class="h.timeClass">{{ h.time }}</h3></i-col>
        </Row>
      </Card>
    </transition-group>
  </div>
</template>

<script>
import Utils from '../js/Utils'
const statsNone = 0
const statsLearn = 1
const statsPractice = 2
const statsTest = 3
export default {
  name: 'LearnAndPractice',
  data () {
    return {
      keycodes: [],
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
    save: function (item, time, isCurrent) {
      if (this.isLearn) {
        return
      }
      let data = Utils.loadStorage(item.key) || {}
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
      Utils.saveStorage(item.key, data)
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
        rand = Math.floor(Math.random() * this.items2current.length)
      } while (this.current_item === this.items2current[rand])
      return this.items2current[rand]
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
      console.log(e.keyCode)
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
      let _key = this.keycodes[e.keyCode]
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
  },
  mounted: function () {
    this.$http.get('/api/keycodes.json').then(r => {
      this.keycodes = r.data
    }).catch(e => { console.log(e) })
  }
}
</script>
