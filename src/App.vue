<script setup>
import { VueFlow } from '@vue-flow/core';
import { markRaw, ref } from 'vue';
import CustomStartNode from './components/CustomStartNode.vue';

const nodeTypes = {
  customStart: markRaw(CustomStartNode),
};

const nodes = ref([
  { 
    id: '1',
    type: 'customStart', 
    position: { x: 250, y: 5 },
    data: { 
      label: '開始',
      description: '工作流的起始節點，用於設置啟動工作流所需的信息。',
      inputs: [
        { name: 'SYS_USER_INPUT', type: 'String', description: '本輪對話的用戶輸入', required: false, isBuiltIn: true },
        { name: 'syntax', type: 'String', description: 'BPMN 語法', required: true, isBuiltIn: false },
      ]
    },
  },
  { 
    id: '2', 
    position: { x: 100, y: 300 },
    data: { label: '節點 2' },
  },
  { 
    id: '3', 
    type: 'output', 
    position: { x: 400, y: 400 },
    data: { label: '節點 3' },
  },
]);

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
]);
</script>

<template>
  <div style="width: 100vw; height: 100vh;">
    <VueFlow :nodes="nodes" :edges="edges" :node-types="nodeTypes" />
  </div>
</template>

<style>
@import '@vue-flow/core/dist/style.css';
@import '@vue-flow/core/dist/theme-default.css';
</style>