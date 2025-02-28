<template>
  <div id="map"></div>
</template>

<script>
 import MindElixir from 'mind-elixir'
 import { QWebChannel } from "qwebchannel"

 export default {
   name: 'App',
   data() {
     return {
       backgroundColor: '#ffffff',
       foregroundColor: '#000000',
       mindElixir: null
     }
   },
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
     initColors(backgroundColor, foregroundColor) {
       this.backgroundColor = backgroundColor;
       this.foregroundColor = foregroundColor;
       
       // 如果已经有实例，更新它的主题
       if (this.mindElixir) {
         this.updateMindElixirTheme();
       }
     },
     updateTheme(backgroundColor, foregroundColor) {
       this.backgroundColor = backgroundColor;
       this.foregroundColor = foregroundColor;
       
       if (this.mindElixir) {
         this.updateMindElixirTheme();
       }
     },
     updateMindElixirTheme() {
       if (this.mindElixir) {
         this.mindElixir.changeTheme({
           name: 'EmacsTheme',
           palette: [this.foregroundColor],
           cssVar: {
             "--main-color": this.foregroundColor,
             "--main-bgcolor": this.backgroundColor,
             "--color": this.foregroundColor,
             "--bgcolor": this.backgroundColor,
             "--panel-color": this.foregroundColor,
             "--panel-bgcolor": this.backgroundColor,
             "--panel-border-color": this.foregroundColor
           }
         }, true);  // 第二个参数true表示立即刷新
       }
     },
     createMindElixir() {
       let options = {
         el: '#map',
         theme: {
           name: 'EmacsTheme',
           palette: [this.foregroundColor],
           cssVar: {
             "--main-color": this.foregroundColor,
             "--main-bgcolor": this.backgroundColor,
             "--color": this.foregroundColor,
             "--bgcolor": this.backgroundColor,
             "--panel-color": this.foregroundColor,
             "--panel-bgcolor": this.backgroundColor,
             "--panel-border-color": this.foregroundColor
           }
         }
       }
       this.mindElixir = new MindElixir(options);
     },
     saveFile() {
       // Mind Elixir的数据保存API
       return JSON.stringify(this.mindElixir.getData())
     },
     open_file(base64Data) {
       // 解码base64数据
       const jsonStr = atob(base64Data);
       const data = JSON.parse(jsonStr);
       
       // 创建Mind Elixir实例
       this.createMindElixir();
       
       // 使用数据初始化思维导图
       this.mindElixir.init(data);
     },
     init_root_node() {
       // 创建新的思维导图数据
       const data = MindElixir.new('EAF Rocks!');
       
       // 创建Mind Elixir实例
       this.createMindElixir();
       
       // 初始化空的思维导图
       this.mindElixir.init(data);
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
     window.initColors = this.initColors;
     window.updateTheme = this.updateTheme;
     window.editCurrentTopic = this.editCurrentTopic;
     window.saveFile = this.saveFile;
     window.open_file = this.open_file;
     window.init_root_node = this.init_root_node;
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
