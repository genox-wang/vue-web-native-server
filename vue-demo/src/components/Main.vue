<template>
  <div class="layout">
    <Menu mode="horizontal" active-name="1">
      <p class="layout-logo">SHORTCUTFOO</p>
    </Menu>
    <div v-if="subject_id === -1" class="layout-content">
      <SubjectsMenu :subjects="subjects" @select="selectSubject"></SubjectsMenu>
    </div>
    <div v-if="subject_id !== -1 && chapter_id === -1" class="layout-content">
      <ChaptersMenu :chapters="current_subject.chapters" @select="selectChapter" @back="backSubject"></ChaptersMenu>
    </div>
    <div v-if="chapter_id !== -1" class="layout-content">
      <LearnAndPractice :current_items="current_items" :chapter_name="current_chapter.name" @back="backChapter"></LearnAndPractice>
    </div>
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

export default {
  name: 'main',
  data () {
    return {
      subject_id: -1, // 课题id
      chapter_id: -1 // 章节id
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
    }
  },
  methods: {
    selectSubject: function (index) {
      this.subject_id = index
    },
    selectChapter: function (index) {
      this.chapter_id = index
    },
    backSubject: function () {
      this.subject_id = -1
    },
    backChapter: function () {
      this.chapter_id = -1
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
.error {
  color: #DD4B39
}
.currect {
  color: #41B883
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
  min-height: 200px;
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


</style>
