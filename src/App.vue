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
       rainbowColors: {
         light: [
           '#E74C3C', // 红色
           '#F39C12', // 橙色
           '#F1C40F', // 黄色
           '#2ECC71', // 绿色
           '#3498DB', // 蓝色
           '#9B59B6', // 紫色
           '#1ABC9C', // 青绿色
           '#D35400', // 深橙色
           '#27AE60', // 深绿色
           '#2980B9'  // 深蓝色
         ],
         dark: [
           '#FF6B6B', // 亮红色
           '#FFAB4C', // 亮橙色
           '#FFD93D', // 亮黄色
           '#6BCB77', // 亮绿色
           '#4D96FF', // 亮蓝色
           '#B983FF', // 亮紫色
           '#56D1C1', // 亮青绿色
           '#FF8C42', // 亮深橙色
           '#59C36A', // 亮深绿色
           '#5DA3E4'  // 亮深蓝色
         ]
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
     initColors(backgroundColor, textColor, colorPalette, rainbowColorsStr) {
       this.backgroundColor = backgroundColor;
       this.textColor = textColor;
       this.colorPalette = colorPalette;
       
       // If passed rainbow color scheme, parse and update it
       if (rainbowColorsStr) {
         this.rainbowColors = {
           light: typeof rainbowColorsStr.light === 'string' ? 
                  rainbowColorsStr.light.split('|') : 
                  this.rainbowColors.light,
           dark: typeof rainbowColorsStr.dark === 'string' ? 
                 rainbowColorsStr.dark.split('|') : 
                 this.rainbowColors.dark
         };
       }
       
       // 如果已经有实例，更新它的主题
       if (this.mindElixir) {
         this.updateMindElixirTheme();
       }
     },
     updateTheme(backgroundColor, textColor, colorPalette, rainbowColorsStr) {
       this.backgroundColor = backgroundColor;
       this.textColor = textColor;
       this.colorPalette = colorPalette;
       
       // If passed rainbow color scheme, parse and update it
       if (rainbowColorsStr) {
         this.rainbowColors = {
           light: typeof rainbowColorsStr.light === 'string' ? 
                  rainbowColorsStr.light.split('|') : 
                  this.rainbowColors.light,
           dark: typeof rainbowColorsStr.dark === 'string' ? 
                 rainbowColorsStr.dark.split('|') : 
                 this.rainbowColors.dark
         };
       }
       
       if (this.mindElixir) {
         this.updateMindElixirTheme();
       }
     },
     updateMindElixirTheme() {
       if (this.mindElixir) {
         // Generate root node background color
         const rootBgColor = this.generateRootBgColor(this.backgroundColor);
         
         // Select appropriate rainbow color scheme for current theme
         const rainbowScheme = this.isLightColor(this.backgroundColor) 
           ? this.rainbowColors.light 
           : this.rainbowColors.dark;
         
         this.mindElixir.changeTheme({
           name: 'EmacsTheme',
           palette: rainbowScheme, // 使用彩虹色方案替代之前的调色板
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
         
         // 应用彩虹色到连接线
         this.applyRainbowColors(rainbowScheme);
       }
     },
     createMindElixir() {
       // Generate root node background color
       const rootBgColor = this.generateRootBgColor(this.backgroundColor);
       
       // Select appropriate rainbow color scheme for current theme
       const rainbowScheme = this.isLightColor(this.backgroundColor) 
         ? this.rainbowColors.light 
         : this.rainbowColors.dark;
       
       let options = {
         el: '#map',
         direction: 2,  // 设置为2表示左右平衡模式
         draggable: true,
         contextMenu: true,
         toolBar: true,
         nodeMenu: true,
         keypress: true,
         locale: 'en',
         theme: {
           name: 'EmacsTheme',
           palette: rainbowScheme,  // 使用彩虹色方案作为调色板
           randomColor: false,      // 关闭随机颜色
           background: this.backgroundColor,
           cssVar: {
             "--root-color": this.colorPalette?.fourth || this.textColor,
             "--root-bgcolor": rootBgColor,
           }
         },
         linkStyle: 'straight', // 连接线样式：'straight' 或 'curve'
       }
       
       this.mindElixir = new MindElixir(options);
       
       // 添加事件监听器
       this.mindElixir.bus.addListener('selectNode', (node) => {
         this.selectedNode = node;
       });
       
       // 在初始化完成后设置颜色
       this.mindElixir.bus.addListener('operation', (operation) => {
         if (['finishInit', 'moveNode', 'addChild', 'addSibling', 'removeNode'].includes(operation.name)) {
           // 延迟一点时间执行，确保DOM已更新
           setTimeout(() => {
             const currentScheme = this.isLightColor(this.backgroundColor) 
               ? this.rainbowColors.light 
               : this.rainbowColors.dark;
             this.applyRainbowColors(currentScheme);
           }, 100);
         }
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
     },
     // 简化 applyRainbowColors 方法，只设置连接线颜色
     applyRainbowColors(colors) {
       if (!this.mindElixir) return;
       
       // 获取所有连接线
       const connections = document.querySelectorAll('.mind-elixir-line');
       if (!connections.length) return;
       
       // 为每个连接线应用彩虹色
       connections.forEach((connection, index) => {
         const colorIndex = index % colors.length;
         connection.style.stroke = colors[colorIndex];
         connection.style.strokeWidth = '2px';
       });
       
       // 处理SVG路径
       const paths = document.querySelectorAll('.mind-elixir-line path');
       paths.forEach((path, index) => {
         const colorIndex = index % colors.length;
         path.style.stroke = colors[colorIndex];
       });
     },
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
