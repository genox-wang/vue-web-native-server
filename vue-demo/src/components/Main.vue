<template>
  <div class="layout">
    <Menu mode="horizontal" active-name="lessons" @on-select="menuChange">
      <row>
        <i-col span="12"><p class="layout-logo">LOOSTUDY FOO</p></i-col>>
        <i-col span="8">
          <Menu-item name="lessons"><h2>Lessons</h2></Menu-item>
          <Menu-item name="analysis"><h2>Analysis</h2></Menu-item>
        </i-col>
      </row>
    </Menu>
    <transition :name="content_transition" mode="out-in">
      <div v-if="currentPane === 'SubjectsMenu'" class="layout-content" key="1">
        <SubjectsMenu :subjects="subjects" @select="selectSubject"></SubjectsMenu>
      </div>
      <div v-else-if="currentPane === 'ChaptersMenu'" class="layout-content" key="2">
        <ChaptersMenu :chapters="current_subject.chapters" @select="selectChapter" @back="backSubject"></ChaptersMenu>
      </div>
      <div v-else-if="currentPane === 'LearnAndPractice'" class="layout-content" key="3">
        <LearnAndPractice :current_items="current_items" :chapter_name="current_chapter.name" :items2current="items2current" @back="backChapter"></LearnAndPractice>
      </div>
      <div class="layout-content" style="height: auto" v-else-if="currentPane === 'Analysis'" key="4">
        <Analysis :itemkeys="keysforAnalysis"></Analysis>
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
import Analysis from './Analysis.vue'

export default {
  name: 'main',
  data () {
    return {
      lessons: [],
      subject_id: -1, // 课题id
      chapter_id: -1, // 章节id
      content_transition: 'left-in', // 页面过渡动画
      currentPane: 'SubjectsMenu' // 当前页面
    }
  },
  components: {
    ChaptersMenu,
    SubjectsMenu,
    LearnAndPractice,
    Analysis
  },
  computed: {
    subjects: function () {
      return this.lessons
    },
    current_subject: function () {
      return this.lessons[this.subject_id]
    },
    current_chapter: function () {
      return this.current_subject.chapters[this.chapter_id]
    },
    current_items: function () {
      return this.current_chapter.items
    },
    items2current: function () {
      let items = []
      for (let i = 0; i < this.current_subject.chapters.length && i <= this.chapter_id; i++) {
        items = items.concat(this.current_subject.chapters[i].items)
      }
      return items
    },
    keysforAnalysis: function () {
      let keys = {}
      this.subjects.forEach((subject) => {
        let subjectName = subject.name
        subject.chapters.forEach((chapter) => {
          let chapterName = chapter.name
          chapter.items.forEach((item) => {
            keys[item.key] = {
              name: item.question,
              chapter: chapterName,
              subject: subjectName
            }
          })
        })
      })
      return keys
    }
  },
  methods: {
    selectSubject: function (index) {
      this.content_transition = 'right-in'
      this.subject_id = index
      this.currentPane = 'ChaptersMenu'
    },
    selectChapter: function (index) {
      this.content_transition = 'right-in'
      this.chapter_id = index
      this.currentPane = 'LearnAndPractice'
    },
    backSubject: function () {
      this.content_transition = 'left-in'
      this.subject_id = -1
      this.currentPane = 'SubjectsMenu'
    },
    backChapter: function () {
      this.content_transition = 'left-in'
      this.chapter_id = -1
      this.currentPane = 'ChaptersMenu'
    },
    menuChange: function (name) {
      this.content_transition = 'up-in'
      switch (name) {
        case 'lessons':
          this.currentPane = 'SubjectsMenu'
          break
        case 'analysis':
          this.currentPane = 'Analysis'
          break
        default:
      }
    }
  },
  mounted: function () {
    this.$http.get('/api/lessons.json').then(response => {
      let lessons = response.data
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
      this.lessons = lessons
    }).catch(error => {
      console.log(error)
    })
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
.icon-box-top-right{
  width: 50px;
  height: 50px;
  margin-right: 10px;
  margin-top: 10px;
  float: right;
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

.up-in-enter-active {
  transition: all .2s ease-in;
}
.up-in-enter{
  transform: translateY(20px);
}


</style>
