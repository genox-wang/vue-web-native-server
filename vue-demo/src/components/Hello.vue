<template>
  <div class="hello">
    <div class="subject">
      <ul>
        <li v-for="( subject, index ) in subjects" :class="{ selected: index === subject_id }" @click="selectSubject(index)">{{ index + 1}}.{{ subject.name }}</li>
      </ul>
    </div>
    <div class="chapter">
      <ul>
        <li v-for="( chapter, index ) in current_subject.chapters" :class="{ selected: index === chapter_id }" @click="selectChapter(index)">{{ index + 1 }}.{{ chapter.name }}</li>
      </ul>
    </div>
    <div class="content">
      <h1>{{ current_chapter.name }}</h1>
      <button @click='start'>start</button></br>
      <h3 v-if="current_item !== undefined">{{ current_item.question }}</h3>
      <input class="box"  @keydown="onKeyup" readonly="true">
      <div v-for="h in history" class="box">
        <h3>{{ h.question }}</h3>
        <p>{{ h.answer }}</p>
        <p :class="h.color">{{ h.myshortcut }}</p>
      </div>
    </div>
  </div>
</template>

<script>
let keycodes = require('../conf/keycodes.json')
let lessons = require('../conf/lessons.json')

export default {
  name: 'hello',
  data () {
    return {
      myshortcut: '',
      subject_id: 0, // 课题id
      chapter_id: 0, // 章节id
      current_item: undefined, // 当前题目
      history: []
    }
  },
  computed: {
    subjects: function () {
      return lessons
    },
    current_subject: function () {
      return lessons[this.subject_id]
    },
    current_chapter: function () {
      return this.current_subject.chapters[this.chapter_id]
    },
    current_items: function () {
      return this.current_chapter.items
    }
  },
  methods: {
    start: function () {
      this.randomItem()
    },
    randomItem: function () {
      let rand = Math.floor(Math.random() * this.current_items.length)
      this.current_item = this.current_items[rand]
    },
    selectSubject: function (index) {
      this.subject_id = index
    },
    selectChapter: function (index) {
      this.chapter_id = index
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
    onKeyup: function (e) {
      console.log(e.keyCode)
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

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.error {
  color: #DD4B39
}
.currect {
  color: #41B883
}
.box {
  border:2px solid #41B883;
  border-radius: 25px;
  width: 300px;
  margin: auto;
  margin-top: 10px
}
ul li{
  list-style-type: none;
}
.subject{
  float: left;
  width: 20%;
  border:2px solid #41B883;
  text-align: left;
  cursor: pointer;

}
.chapter{
  float: left;
  width: 20%;
  border: 2px solid #41B883;
  text-align: left;
  cursor: pointer;
}
.content{
  float: left;
  width: 50%;
}

.selected{
  font-size: 20px
}

</style>
