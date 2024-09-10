<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { ref, watch } from 'vue';

interface KMNodeData {
  label: string;
  query: string;
  knowledge: string[];
  searchStrategy: string;
  maxRecalls: number;
  minMatchingDegree: number;
}

const { node } = useNode<KMNodeData>();

const query = ref(node.data.query || '');
const knowledge = ref<string[]>(node.data.knowledge || ['test']);
const searchStrategy = ref(node.data.searchStrategy || 'Semantics');
const maxRecalls = ref(node.data.maxRecalls || 1);
const minMatchingDegree = ref(node.data.minMatchingDegree || 0.5);

const updateNodeData = () => {
  node.data = {
    ...node.data,
    query: query.value,
    knowledge: knowledge.value,
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

watch([query, knowledge, searchStrategy, maxRecalls, minMatchingDegree], updateNodeData, { deep: true });
</script>

<template>
  <div class="node km-node">
    <Handle type="target" :position="Position.Left" />
    
    <div class="node-header">
      <h3>Knowledge</h3>
      <p>In the selected knowledge, the best matching information is recalled based on the input variable and returned as an Array.</p>
    </div>
    
    <div class="node-content">
      <!-- <div class="section">
        <h4>Enter</h4>
        <div class="input-row">
          <label for="query">Query*</label>
          <input id="query" v-model="query" placeholder="String">
        </div>
        <div class="input-row">
          <label for="reference">Reference</label>
          <select id="reference" v-model="reference">
            <option value="Reference">Reference</option>
            <option value="Start - BOT_USE">Start - BOT_USE</option>
          </select>
        </div>
      </div> -->
      
      <div class="section">
        <h4>Knowledge</h4>
        <div v-for="(item, index) in knowledge" :key="index" class="input-row">
          <input v-model="knowledge[index]" placeholder="Knowledge item">
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