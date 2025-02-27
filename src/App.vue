<template>
  <div id="map"></div>
</template>

<script>
 import MindElixir from 'mind-elixir'

 export default {
   name: 'App',
   components: {
   },
   mounted() {
     let options = {
       el: '#map', // or HTMLDivElement
     }

     let mind = new MindElixir(options)

     // create new map data
     const data = MindElixir.new('new topic')
     mind.init(data)
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
