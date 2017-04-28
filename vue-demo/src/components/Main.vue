<template>
  <div class="layout">
    <Menu mode="horizontal" active-name="1">
      <p class="layout-logo">LOOSTUDY FOO</p>
    </Menu>
    <transition :name="content_transition" mode="out-in">
      <div v-if="subject_id === -1" class="layout-content" key="1">
        <SubjectsMenu :subjects="subjects" @select="selectSubject"></SubjectsMenu>
      </div>
      <div v-else-if="chapter_id === -1" class="layout-content" key="2">
        <ChaptersMenu :chapters="current_subject.chapters" @select="selectChapter" @back="backSubject"></ChaptersMenu>
      </div>
      <div v-else class="layout-content" key="3">
        <LearnAndPractice :current_items="current_items" :chapter_name="current_chapter.name" :items2current="items2current" @back="backChapter"></LearnAndPractice>
      </div>
    </transition>
    <div class="layout-copy">
        2017 &copy; loostudy
    </div>
  </div>
</template>

<script>
import ChaptersMenu from './ChaptersMenu.vue'
import SubjectsMenu from './SubjectsMenu.vue'
import LearnAndPractice from './LearnAndPractice.vue'
let lessons = require('../conf/lessons.json')

lessons.map((subject) => {
  let subjectKey = subject.key
  subject.chapters.map((chapter) => {
    let chapterKey = chapter.key
    chapter.items.map((item) => {
      item.key = subjectKey + '-' + chapterKey + '-' + item.key
      return item
    })
    return chapter
  })
  return subject
})

export default {
  name: 'main',
  data () {
    return {
      subject_id: -1, // 课题id
      chapter_id: -1, // 章节id
      content_transition: 'left-in' // 页面过渡动画
    }
  },
  components: {
    ChaptersMenu,
    SubjectsMenu,
    LearnAndPractice
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
    },
    items2current: function () {
      let items = []
      for (var i = 0; i < this.current_subject.chapters.length && i <= this.chapter_id; i++) {
        items = items.concat(this.current_subject.chapters[i].items)
      }
      return items
    }
  },
  methods: {
    selectSubject: function (index) {
      this.content_transition = 'right-in'
      this.subject_id = index
    },
    selectChapter: function (index) {
      this.content_transition = 'right-in'
      this.chapter_id = index
    },
    backSubject: function () {
      this.content_transition = 'left-in'
      this.subject_id = -1
    },
    backChapter: function () {
      this.content_transition = 'left-in'
      this.chapter_id = -1
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.error,.speed-slow {
  color: #DD4B39
}
.currect,.speed-fast {
  color: #41B883
}

.speed-mid {
  color: orange
}

.layout{
  border: 1px solid #d7dde4;
  background: #f5f7f9;
  /*min-height: 600px;*/
}

.layout-logo{
  font-size: 30px;
  color: #41B883;
  font-weight: bolder;
  float: left;
  position: relative;
  left: 60px;
}

.layout-content{
  height:536px;
  margin: 30px 60px;
  overflow: hidden;
  background: #fff;
  border-radius: 4px;
}
.layout-copy{
  text-align: center;
  padding: 10px 0 20px;
  color: #9ea7b4;
}

.menu-box{
  text-align: center;
  vertical-align: middle;
  margin: 10px;
  cursor: pointer;
}
.back-box{
  width: 50px;
  height: 50px;
  margin-left: 10px;
  margin-top: 10px;
}
.title{
  font-size: 25px;
  text-align: center;
  margin: 10px
}

.pop-enter-active{
  transition: all .2s ease-in;
}
.pop-enter{
  transform: scaleY(.3);
}

.right-in-enter-active {
  transition: all .2s ease-in;
}
.right-in-enter{
  transform: translateX(60px);
}

.left-in-enter-active {
  transition: all .2s ease-in;
}
.left-in-enter{
  transform: translateX(-60px);
}

</style>
