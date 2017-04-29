export default {
  saveStorage: function (key, json) {
    window.localStorage.setItem(key, JSON.stringify(json))
  },
  loadStorage: function (key) {
    return JSON.parse(window.localStorage.getItem(key))
  },
  toSecond: function (time) {
    let s = Math.floor(time / 1000)
    let ms = Math.round((time % 1000) / 10)
    return s + '\'' + ms + '"'
  }
}
