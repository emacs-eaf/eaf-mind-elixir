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
       textColor: '#000000',
       colorPalette: {
         main: '#000000',
         second: '#000000',
         third: '#000000',
         fourth: '#000000',
         fifth: '#000000',
         sixth: '#000000',
         seventh: '#000000',
         eighth: '#000000',
         ninth: '#000000',
         tenth: '#000000'
       },
       mindElixir: null,
       selectedNode: null
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
     initColors(backgroundColor, textColor, colorPalette) {
       this.backgroundColor = backgroundColor;
       this.textColor = textColor;
       this.colorPalette = colorPalette;
       
       // 如果已经有实例，更新它的主题
       if (this.mindElixir) {
         this.updateMindElixirTheme();
       }
     },
     updateTheme(backgroundColor, textColor, colorPalette) {
       this.backgroundColor = backgroundColor;
       this.textColor = textColor;
       this.colorPalette = colorPalette;
       
       if (this.mindElixir) {
         this.updateMindElixirTheme();
       }
     },
     updateMindElixirTheme() {
       if (this.mindElixir) {
         this.mindElixir.changeTheme({
           name: 'EmacsTheme',
           palette: [
             this.colorPalette.main,
             this.colorPalette.second,
             this.colorPalette.third,
             this.colorPalette.fourth,
             this.colorPalette.fifth,
             this.colorPalette.sixth,
             this.colorPalette.seventh,
             this.colorPalette.eighth,
             this.colorPalette.ninth,
             this.colorPalette.tenth
           ],
           cssVar: {
             "--main-color": this.colorPalette.main,
             "--main-bgcolor": this.backgroundColor,
             "--color": this.textColor,
             "--bgcolor": this.backgroundColor,
             "--panel-color": this.colorPalette.second,
             "--panel-bgcolor": this.backgroundColor,
             "--panel-border-color": this.colorPalette.third,
             "--root-color": this.colorPalette.fourth,
             "--root-bgcolor": this.colorPalette.fifth,
             "--primary-color": this.colorPalette.sixth,
             "--selection-color": this.colorPalette.seventh,
             "--line-color": this.colorPalette.eighth,
             "--hover-color": this.colorPalette.ninth,
             "--warning-color": this.colorPalette.tenth
           }
         }, true);
       }
     },
     createMindElixir() {
       let options = {
         el: '#map',
         theme: {
           name: 'EmacsTheme',
           palette: [
             this.colorPalette?.main || this.textColor,
             this.colorPalette?.second || this.textColor,
             this.colorPalette?.third || this.textColor,
             this.colorPalette?.fourth || this.textColor,
             this.colorPalette?.fifth || this.textColor,
             this.colorPalette?.sixth || this.textColor,
             this.colorPalette?.seventh || this.textColor,
             this.colorPalette?.eighth || this.textColor,
             this.colorPalette?.ninth || this.textColor,
             this.colorPalette?.tenth || this.textColor
           ],
           cssVar: {
             "--main-color": this.colorPalette?.main || this.textColor,
             "--main-bgcolor": this.backgroundColor,
             "--color": this.textColor,
             "--bgcolor": this.backgroundColor,
             "--panel-color": this.colorPalette?.second || this.textColor,
             "--panel-bgcolor": this.backgroundColor,
             "--panel-border-color": this.colorPalette?.third || this.textColor,
             "--root-color": this.colorPalette?.fourth || this.textColor,
             "--root-bgcolor": this.colorPalette?.fifth || this.backgroundColor,
             "--primary-color": this.colorPalette?.sixth || this.textColor,
             "--selection-color": this.colorPalette?.seventh || this.textColor,
             "--line-color": this.colorPalette?.eighth || this.textColor,
             "--hover-color": this.colorPalette?.ninth || this.textColor,
             "--warning-color": this.colorPalette?.tenth || this.textColor
           }
         }
       }
       this.mindElixir = new MindElixir(options);
       
       // 添加事件监听器，在节点被选中时更新currentNode
       this.mindElixir.bus.addListener('selectNode', (node) => {
         console.log('Node selected:', node);
         this.selectedNode = node;
       });
     },
     saveFile() {
       // Mind Elixir的数据保存API
       return JSON.stringify(this.mindElixir.getData())
     },
     openFile(base64Data) {
       // 解码base64数据
       const jsonStr = atob(base64Data);
       const data = JSON.parse(jsonStr);
       
       // 创建Mind Elixir实例
       this.createMindElixir();
       
       // 使用数据初始化思维导图
       this.mindElixir.init(data);
     },
     initRootNode() {
       // 创建新的思维导图数据
       const data = MindElixir.new('EAF Rocks!');
       
       // 创建Mind Elixir实例
       this.createMindElixir();
       
       // 初始化空的思维导图
       this.mindElixir.init(data);
     },
     zoomIn() {
       if (this.mindElixir) {
         // 在当前缩放基础上放大10%
         const currentScale = this.mindElixir.scaleVal || 1;
         this.mindElixir.scale(currentScale * 1.1);
       }
     },
     zoomOut() {
       if (this.mindElixir) {
         // 在当前缩放基础上缩小10%
         const currentScale = this.mindElixir.scaleVal || 1;
         this.mindElixir.scale(currentScale * 0.9);
       }
     },
     zoomReset() {
       if (this.mindElixir) {
         // 直接重置到1.0
         this.mindElixir.scale(1);
       }
     },
     setNodeTopic(text) {
       if (this.mindElixir && this.mindElixir.currentNode) {
         // 使用setNodeTopic API设置当前选中节点的标题
         this.mindElixir.setNodeTopic(this.mindElixir.currentNode, text);
       }
     },
     getNodeTopic() {
       // 优先使用selectedNode
       if (this.selectedNode) {
         return this.selectedNode.topic;
       }
       
       // 尝试使用currentNode
       if (this.mindElixir && this.mindElixir.currentNode) {
         return this.mindElixir.currentNode.topic;
       }
       
       // 尝试从DOM获取
       const selectedElement = document.querySelector('.selected');
       if (selectedElement) {
         const topicElement = selectedElement.querySelector('.topic');
         if (topicElement) {
           return topicElement.textContent;
         }
       }
       
       // 最后返回根节点
       if (this.mindElixir && this.mindElixir.nodeData) {
         return this.mindElixir.nodeData.topic;
       }
       
       return null;
     },
     debugNodeInfo() {
       const result = {
         hasInstance: !!this.mindElixir,
         hasCurrentNode: this.mindElixir && !!this.mindElixir.currentNode,
         selectedInDOM: !!document.querySelector('.selected'),
         rootTopic: this.mindElixir ? this.mindElixir.nodeData.topic : null
       };
       
       // 尝试获取选中节点的信息
       const selectedNode = document.querySelector('.selected');
       if (selectedNode) {
         result.selectedNodeId = selectedNode.getAttribute('data-nodeid');
         result.selectedNodeText = selectedNode.querySelector('.topic') ? 
                                  selectedNode.querySelector('.topic').textContent : null;
       }
       
       return JSON.stringify(result);
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
     window.openFile = this.openFile;
     window.initRootNode = this.initRootNode;
     window.zoomIn = this.zoomIn;
     window.zoomOut = this.zoomOut;
     window.zoomReset = this.zoomReset;
     window.setNodeTopic = this.setNodeTopic;
     window.getNodeTopic = this.getNodeTopic;
     window.debugNodeInfo = this.debugNodeInfo;
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
