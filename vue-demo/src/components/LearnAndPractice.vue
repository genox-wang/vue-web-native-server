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
      <Col span="8"><Card class="menu-box" style="background: #86D9FB; color: white;"><h2>Learn</h2></Card></Col>
      <Col span="8"><Card class="menu-box" style="background: #41B883;; color: white;" @click.native='practice'><h2>Practice</h2></Card></Col>
      <Col span="8"><Card class="menu-box" style="background: #F3625D; color: white;"><h2>Test</h2></Card></Col>
    </Row>
    <input ref="input" style="height: 0"  @keydown="onKeyDown" @blur="onBlur" readonly="true">
    <Card class="menu-box">
      <Row>
        <Col span="4" style="text-align: left; padding-left: 20px"><h2>Question:</h2></Col>
        <Col span="16"><h2 v-if="current_item !== undefined">{{ current_item.question }}</h2></Col>
      </Row>
    </Card>
    <Card v-for="h in history" class="menu-box" :key="1">
      <Row>
        <Col span="8" style="text-align: left; padding-left: 20px"><h3>{{ h.question }}</h3></Col>
        <Col span="8"><h3>{{ h.answer }}</h3></Col>
        <Col span="8"><h3 :class="h.color">{{ h.myshortcut }}</h3></Col>
      </Row>
    </Card>
  </div>
</template>

<script>
let keycodes = require('../conf/keycodes.json')
export default {
  name: 'LearnAndPractice',
  data () {
    return {
      myshortcut: '',
      current_item: undefined, // 当前题目
      history: []
    }
  },
  props: [
    'current_items',
    'chapter_name'
  ],
  methods: {
    back: function () {
      this.$emit('back')
    },
    practice: function () {
      // console.log('aaa')
      this.randomItem()
      this.$refs.input.focus()
    },
    randomItem: function () {
      let rand = Math.floor(Math.random() * this.current_items.length)
      this.current_item = this.current_items[rand]
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
      this.$refs.input.focus()
    },
    onKeyDown: function (e) {
      // console.log(e.keyCode)
      e.preventDefault()
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
        myshortcut += _key
        if (!this.current_item.answer.includes(' ') || myshortcut.includes(' ')) {
          this.myshortcut = ''
          this.history.unshift({
            question: this.current_item.question,
            answer: this.current_item.answer,
            myshortcut: myshortcut,
            color: this.compareShortcuts(this.current_item.answer, myshortcut) ? 'currect' : 'error'
          })
          if (this.history.length > 4) {
            this.history.pop()
          }
          this.randomItem()
        } else {
          this.myshortcut = myshortcut + ' '
        }
      }
    }
  }
}
</script>
