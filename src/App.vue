<script setup>
import { Background } from '@vue-flow/background';
import { Controls } from '@vue-flow/controls';
import { VueFlow, useVueFlow } from '@vue-flow/core';
import { MiniMap } from '@vue-flow/minimap';
import { markRaw, ref } from 'vue';

import LLMNode from './components/LLMNode.vue';
import SaveRestoreControls from './components/SaveRestoreControls.vue';
import Sidebar from './components/Sidebar.vue';
import StartNode from './components/StartNode.vue';

// 導入控制面板樣式
import '@vue-flow/controls/dist/style.css';
import '@vue-flow/minimap/dist/style.css';

const nodeTypes = {
  start: markRaw(StartNode),
  llm: markRaw(LLMNode),
};

const nodes = ref([
  {
    id: '1',
    type: 'start',
    position: { x: 250, y: 5 },
    data: {
      label: '開始',
      description: '工作流的起始節點，用於設置啟動工作流所需的信息。',
      inputs: [
        { name: 'BOT_USER_INPUT', type: 'String', description: '本輪對話的用戶輸入', required: false, isBuiltIn: true },
        { name: 'syntax', type: 'String', description: 'BPMN 語法', required: true, isBuiltIn: true },
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
  {
    id: '4',
    type: 'llm',
    position: { x: 250, y: 200 },
    data: {
      label: 'LLM Node',
      model: 'GPT-3.5 Turbo',
      inputs: [],
      prompt: '',
      outputs: [],
    },
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

const { onConnect, addNodes, addEdges } = useVueFlow();


onConnect((params) => {
  // 當用戶手動連接兩個節點時，創建一個新的邊
  const newEdge = {
    id: `e${params.source}-${params.target}`,
    source: params.source,
    target: params.target,
  };
  edges.value.push(newEdge);
});

const onZoomIn = () => console.log('Zoomed in');
const onZoomOut = () => console.log('Zoomed out');
const onFitView = () => console.log('View fitted');
const onInteractionChange = (interactionEnabled) => console.log('Interaction changed:', interactionEnabled);

const handleAddNode = (type) => {
  const newNode = {
    id: `${type}-${Date.now()}`,
    type,
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    data: {
      label: `${type.charAt(0).toUpperCase() + type.slice(1)} Node`,
      // 如果是 LLM 节点，添加特定的数据
      ...(type === 'llm' ? {
        model: 'GPT-3.5 Turbo',
        inputs: [],
        prompt: '',
        outputs: [],
      } : {})
    },
  };
  addNodes([newNode]);
};

</script>

<template>
  <div style="width: 100vw; height: 100vh;">
    <VueFlow :default-viewport="{ zoom: 0.5, x: 0, y: 0 }" v-model:nodes="nodes" v-model:edges="edges" :node-types="nodeTypes" :connect-on-click="true">
      <Background pattern-color="#aaa" :gap="16" />
      <MiniMap>
      </MiniMap>
      <Controls @zoom-in="onZoomIn" @zoom-out="onZoomOut" @fit-view="onFitView" @interaction-change="onInteractionChange" />
      <SaveRestoreControls />
      <!-- <Panel :position="PanelPosition.TopRight">
        <button style="margin-right: 5px">reset transform</button>
        <button style="margin-right: 5px">change pos</button>
        <button style="margin-right: 5px">toggle class</button>
        <button>toObject</button>
      </Panel> -->
    </VueFlow>
    <Sidebar @addNode="handleAddNode" />
  </div>
</template>

<style>
@import '@vue-flow/core/dist/style.css';
@import '@vue-flow/core/dist/theme-default.css';
@import './assets/commonStyles.css';
</style>