<template>
  <div>
    <div class="title">
      <h2>Subjects</h2>
    </div>
    <Row v-for="ss in subjectsGrid" :key="1">
      <Col v-for="subject in ss" :key="subject.index" span="8"><Card class="menu-box" @click.native="select(subject.index)"><h2>{{ subject.name }}</h2></Card></Col>
    </Row>

  </div>
</template>

<script>
export default {
  name: 'SubjectsMenu',
  props: ['subjects'],
  computed: {
    subjectsGrid: function () {
      let col = 3 // 一行3个
      let gridArr = []  // 暂存格栅数组
      for (var i = 0; i < this.subjects.length; i++) {
        if (i % col === 0) {
          gridArr.push([])
        }
        gridArr[Math.floor(i / col)].push({ index: i, name: this.subjects[i].name })
      }
      return gridArr
    }
  },
  methods: {
    select: function (index) {
      this.$emit('select', index)
    }
  }
}
</script>
