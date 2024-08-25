<script setup>
import { Panel, useVueFlow } from '@vue-flow/core';

const flowKey = 'vue-flow--save-restore'

const { nodes, edges, addNodes, toObject, fromObject } = useVueFlow()

function onSave() {
  console.log('Saving flow to localStorage' + JSON.stringify(toObject()))
  localStorage.setItem(flowKey, JSON.stringify(toObject()))
}

function onRestore() {
  const flow = JSON.parse(localStorage.getItem(flowKey))
  if (flow) {
    fromObject(flow)
  }
}

function onAddRandomNode() {
  const newNode = {
    id: `random-${Date.now()}`,
    type: Math.random() > 0.5 ? 'start' : 'llm',
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    data: { label: `Random Node ${nodes.value.length + 1}` },
  }
  addNodes([newNode])
}
</script>

<template>
  <Panel position="top-right" class="save-restore-controls">
    <button title="保存图表" @click="onSave">💾</button>
    <button title="恢复图表" @click="onRestore">📂</button>
    <button title="添加随机节点" @click="onAddRandomNode">➕</button>
  </Panel>
</template>

<style scoped>
.save-restore-controls {
  display: flex;
  gap: 5px;
}

button {
  background-color: #4a5568;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background-color: #2d3748;
}

.vue-flow__panel {
  background-color: #b4c6f9;
  padding: 5px;
  border-radius: 4px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
</style>