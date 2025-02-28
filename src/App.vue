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
         // 生成根节点背景色
         const rootBgColor = this.generateRootBgColor(this.backgroundColor);
         
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
             "--root-bgcolor": rootBgColor,
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
       // 生成根节点背景色
       const rootBgColor = this.generateRootBgColor(this.backgroundColor);
       
       let options = {
         el: '#map',
         direction: 2,  // 设置为2表示左右平衡模式
         draggable: true,  // 允许拖动
         contextMenu: true,  // 启用右键菜单
         toolBar: true,  // 显示工具栏
         nodeMenu: true,  // 启用节点菜单
         keypress: true,  // 启用键盘快捷键
         locale: 'en',  // 设置语言
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
             "--root-bgcolor": rootBgColor,
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
     },
     focusRootNode() {
       if (this.mindElixir) {
         try {
           // 尝试获取根节点ID
           const rootId = this.mindElixir.nodeData.id;
           
           // 使用selectNode方法选中根节点
           this.mindElixir.selectNode(rootId);
           
           // 或者尝试使用DOM方法
           const rootElement = document.querySelector('.root');
           if (rootElement) {
             rootElement.click();
             
             // 如果需要编辑，可以在选中后调用editTopic
             setTimeout(() => {
               if (this.mindElixir.currentNode) {
                 this.mindElixir.editTopic(this.mindElixir.currentNode);
               }
             }, 100);
           }
         } catch (error) {
           console.error('Error focusing root node:', error);
         }
       }
     },
     // 添加一个辅助方法来判断颜色亮度
     isLightColor(color) {
       // 移除#前缀
       const hex = color.replace('#', '');
       
       // 将颜色转换为RGB
       const r = parseInt(hex.substr(0, 2), 16);
       const g = parseInt(hex.substr(2, 2), 16);
       const b = parseInt(hex.substr(4, 2), 16);
       
       // 计算亮度 (基于人眼对不同颜色的感知)
       const brightness = (r * 299 + g * 587 + b * 114) / 1000;
       
       // 亮度大于128认为是浅色
       return brightness > 128;
     },
     // 根据背景色生成根节点背景色
     generateRootBgColor(bgColor) {
       const hex = bgColor.replace('#', '');
       const r = parseInt(hex.substr(0, 2), 16);
       const g = parseInt(hex.substr(2, 2), 16);
       const b = parseInt(hex.substr(4, 2), 16);
       
       // 如果是浅色背景，稍微加深
       if (this.isLightColor(bgColor)) {
         const darkenFactor = 0.9; // 减少10%亮度
         const newR = Math.floor(r * darkenFactor);
         const newG = Math.floor(g * darkenFactor);
         const newB = Math.floor(b * darkenFactor);
         return `#${newR.toString(16).padStart(2, '0')}${newG.toString(16).padStart(2, '0')}${newB.toString(16).padStart(2, '0')}`;
       } else {
         // 如果是深色背景，稍微变亮
         const lightenFactor = 1.3; // 增加30%亮度，但不超过255
         const newR = Math.min(255, Math.floor(r * lightenFactor));
         const newG = Math.min(255, Math.floor(g * lightenFactor));
         const newB = Math.min(255, Math.floor(b * lightenFactor));
         return `#${newR.toString(16).padStart(2, '0')}${newG.toString(16).padStart(2, '0')}${newB.toString(16).padStart(2, '0')}`;
       }
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
     window.focusRootNode = this.focusRootNode;
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
