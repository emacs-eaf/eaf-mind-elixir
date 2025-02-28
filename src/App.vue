<template>
  <div id="map"></div>
</template>

<script>
 import MindElixir from 'mind-elixir'
 import { QWebChannel } from "qwebchannel"

 export default {
   name: 'App',
   components: {
   },
   methods: {
     editCurrentTopic() {
       // 获取当前选中的节点
       const selectedNode = this.mindElixir.currentNode
       
       // 如果有选中的节点，则进入编辑模式
       if (selectedNode) {
         this.mindElixir.editTopic(selectedNode)
       }
     },
     initMindElixir(backgroundColor, foregroundColor) {
       let options = {
         el: '#map',
         theme: {
           name: 'EmacsTheme',
           palette: [foregroundColor],  // 使用前景色作为调色板
           cssVar: {
             "--main-color": foregroundColor,
             "--main-bgcolor": backgroundColor,
             "--color": foregroundColor,
             "--bgcolor": backgroundColor,
             "--panel-color": foregroundColor,
             "--panel-bgcolor": backgroundColor,
             "--panel-border-color": foregroundColor
           }
         }
       }

       // 保存mind实例到this，这样其他方法可以访问
       this.mindElixir = new MindElixir(options)

       // create new map data
       const data = MindElixir.new('new topic')
       this.mindElixir.init(data)
     }
   },
   created() {
     // eslint-disable-next-line no-undef
     new QWebChannel(qt.webChannelTransport, channel => {
       window.pyobject = channel.objects.pyobject;
     });
   },
   mounted() {
     // 将方法暴露给全局，供Python调用
     window.initMindElixir = this.initMindElixir
     window.editCurrentTopic = this.editCurrentTopic
   }
 }
</script>

<style>
 #map {
   display: flex;
   flex-direction: column;
   align-items: center;
   justify-content: center;
   width: 100%;
   height: 100%;
 }

 html, body {
   width: 100%;
   height: 100%;
   margin: 0;
   padding: 0;
 }
</style>
