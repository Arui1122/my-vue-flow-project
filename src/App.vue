<script setup>
   import { VueFlow } from '@vue-flow/core';
import { ref } from 'vue';

   const nodes = ref([
     { 
       id: '1',
       type: 'input', 
       position: { x: 250, y: 5 },
       data: { label: '節點 1' },
     },
     { 
       id: '2', 
       position: { x: 100, y: 100 },
       data: { label: '節點 2' },
     },
     { 
       id: '3', 
       type: 'output', 
       position: { x: 400, y: 200 },
       data: { label: '節點 3' },
     },
   ])

   const edges = ref([
     { 
       id: 'e1-2',
       source: '1', 
       target: '2',
     },
     { 
       id: 'e2-3',
       source: '2', 
       target: '3', 
       animated: true,
     },
   ])
   </script>

   <template>
     <div style="width: 100vw; height: 100vh;">
       <VueFlow :nodes="nodes" :edges="edges" />
     </div>
   </template>

   <style>
   @import '@vue-flow/core/dist/style.css';
   @import '@vue-flow/core/dist/theme-default.css';
   </style>