<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { ref, watch } from 'vue';

interface KMNodeData {
  knowledgeIds: string[];
  searchStrategy: string;
  maxRecalls: number;
  minMatchingDegree: number;
}

const { node } = useNode<KMNodeData>();

const knowledgeIds = ref<string[]>(node.data.knowledgeIds || ['test']);
const searchStrategy = ref(node.data.searchStrategy || 'Semantics');
const maxRecalls = ref(node.data.maxRecalls || 1);
const minMatchingDegree = ref(node.data.minMatchingDegree || 0.5);

const updateNodeData = () => {
  node.data = {
    ...node.data,
    knowledgeIds: knowledgeIds.value,
    searchStrategy: searchStrategy.value,
    maxRecalls: maxRecalls.value,
    minMatchingDegree: minMatchingDegree.value,
  };
};

const addKnowledge = () => {
  knowledge.value.push('New Knowledge');
};

const removeKnowledge = (index: number) => {
  knowledge.value.splice(index, 1);
};

watch([knowledgeIds, searchStrategy, maxRecalls, minMatchingDegree], updateNodeData, { deep: true });
</script>

<template>
  <div class="node km-node">
    <Handle type="target" :position="Position.Left" />
    
    <div class="node-header">
      <h3>Knowledge ({{ node.id }})</h3>
      <p>在選定的知識庫中，根據輸入找出最相似的資訊提供。</p>
    </div>
    
    <div class="node-content">
      <div class="section">
        <h4>Knowledge</h4>
        <div v-for="(item, index) in knowledgeIds" :key="index" class="input-row">
          <input v-model="knowledgeIds[index]" placeholder="Knowledge item">
          <button @click="removeKnowledge(index)" aria-label="Remove knowledge">-</button>
        </div>
        <button @click="addKnowledge">+ Add Knowledge</button>
      </div>
      
      <div class="section">
        <h4>Search strategy</h4>
        <select v-model="searchStrategy">
          <option value="Semantics">Semantics</option>
          <option value="Keyword">Keyword</option>
        </select>
      </div>
      
      <div class="section">
        <h4>Maximum recalls</h4>
        <input type="range" v-model="maxRecalls" min="1" max="20" step="1">
        <span>{{ maxRecalls }}</span>
      </div>
      
      <div class="section">
        <h4>Minimum matching degree</h4>
        <input type="range" v-model="minMatchingDegree" min="0.01" max="0.99" step="0.01">
        <span>{{ minMatchingDegree.toFixed(2) }}</span>
      </div>
    </div>
    
    <Handle type="source" :position="Position.Right" />
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';

/* .km-node {
  background-color: #f0f0f0;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 10px;
  width: 300px;
} */

/* .input-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
}

.input-row input, .input-row select {
  width: 70%;
}

.section {
  margin-bottom: 15px;
}

h4 {
  margin-bottom: 5px;
} */
</style>