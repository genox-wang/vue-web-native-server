<template>
  <div>
    <div class="title">
      <h2>Analysis</h2>
    </div>
    <Table :columns="columns" :data="datas" style="margin: 10px"></Table>
  </div>
</template>

<script>
import Utils from '../js/Utils'
export default {
  name: 'Analysis',
  props: [
    'itemkeys'
  ],
  data () {
    return {
      columns: [
        {
          title: 'Name',
          key: 'name',
          width: 200,
          fixed: 'left',
          render (row, column, index) {
            return `<strong>${row.name}</strong>`
          }
        },
        {
          title: 'Fastest',
          key: 'fastest',
          width: 100,
          sortable: 'true',
          align: 'center',
          render (row, column, index) {
            let fastest = Utils.toSecond(row.fastest)
            return `<p>${fastest}</p>`
          }
        },
        {
          title: 'Avg',
          key: 'avg',
          width: 100,
          sortable: 'true',
          align: 'center',
          render (row, column, index) {
            let avg = Utils.toSecond(row.avg)
            return `<p>${avg}</p>`
          }
        },
        {
          title: 'Slowest',
          key: 'slowest',
          width: 100,
          sortable: 'true',
          align: 'center',
          render (row, column, index) {
            let slowest = Utils.toSecond(row.slowest)
            return `<p>${slowest}</p>`
          }
        },
        {
          title: 'Rate',
          key: 'rate',
          width: 100,
          sortable: 'true',
          align: 'center',
          render (row, column, index) {
            return `<p>${row.rate + '%'}</p>`
          }
        },
        {
          title: 'Times',
          key: 'times',
          width: 100,
          sortable: 'true',
          align: 'center'
        },
        {
          title: 'Chapter',
          key: 'chapter',
          width: 200
        },
        {
          title: 'Subject',
          key: 'subject',
          width: 100,
          align: 'center'
        }
      ],
      datas: []
    }
  },
  methods: {
    back: function () {
      this.$emit('back')
    },
    loadDatas: function () {
      let alldatas = []
      for (let key in this.itemkeys) {
        if (key.startsWith('3')) { // 暂时只显示WebStorm的成绩
          let itemdatas = Utils.loadStorage(key)
          if (itemdatas) {
            alldatas[key] = itemdatas
          }
        }
      }
      this.analyseData(alldatas)
    },
    analyseData: function (alldatas) {
      let mydatas = []
      for (let key in alldatas) {
        let data = alldatas[key]
        let fastest = 999999
        let slowest = 0
        let rate = 0
        let currect = 0
        let times = 0
        let avg = 0
        for (let k in data) {
          let d = data[k]
          if (d.fastest) { fastest = Math.min(d.fastest, fastest) }
          if (d.slowest) { slowest = Math.max(d.slowest, slowest) }
          times += d.times
          currect += d.currect
          if (d.avg) { avg += d.avg * d.currect }
        }
        avg = Math.round(avg / currect)
        rate = Math.floor(currect * 100 / times)
        mydatas.push({
          name: this.itemkeys[key].name,
          subject: this.itemkeys[key].subject,
          chapter: this.itemkeys[key].chapter,
          fastest: fastest,
          avg: avg,
          slowest: slowest,
          rate: rate,
          times: times,
          cellClassName: {
            fastest: this.getTimeClass(fastest),
            avg: this.getTimeClass(avg),
            slowest: this.getTimeClass(slowest),
            rate: this.getRateClass(rate)
          }
        })
      }
      mydatas.sort((a, b) => {
        return a.avg < b.avg ? 1 : -1
      })
      this.datas = mydatas
    },
    getTimeClass: function (time) {
      let c = 'cell-green'
      if (time >= 5000) {
        c = 'cell-orange'
      } else if (time >= 3000) {
        c = 'cell-blue'
      }
      return c
    },
    getRateClass: function (rate) {
      let c = 'cell-green'
      if (rate <= 80) {
        c = 'cell-orange'
      } else if (rate <= 90) {
        c = 'cell-blue'
      }
      return c
    }
  },
  mounted: function () {
    this.loadDatas()
  }
}
</script>

<style>
.ivu-table .cell-green{
  background-color: #00CC66;
  color: white;
}
.ivu-table .cell-orange{
  background-color: #ff6600;
  color: white;
}
.ivu-table .cell-blue{
  background-color: #2DB7F5;
  color: white;
}
</style>
