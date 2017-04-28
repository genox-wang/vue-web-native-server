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
          <h2>Chapters</h2>
        </div>
      </Col>
    </Row>
    <Row v-for="( cs, key ) in chaptersGrid" :key="key">
      <Col v-for="chapter in cs" :key="chapter.index" span="8"><Card class="menu-box" @click.native="select(chapter.index)"><h2>{{ chapter.name }}</h2></Card></Col>
    </Row>

  </div>
</template>

<script>
export default {
  name: 'ChaptersMenu',
  props: ['chapters'],
  computed: {
    chaptersGrid: function () {
      let col = 3 // 一行3个
      let gridArr = []  // 暂存格栅数组
      for (var i = 0; i < this.chapters.length; i++) {
        if (i % col === 0) {
          gridArr.push([])
        }
        gridArr[Math.floor(i / col)].push({ index: i, name: this.chapters[i].name })
      }
      return gridArr
    }
  },
  methods: {
    select: function (index) {
      this.$emit('select', index)
    },
    back: function () {
      this.$emit('back')
    }
  }
}
</script>

<style>
.backbtn{
  position: absolute;
  top: 10px;
  left: 10px;
}
</style>
