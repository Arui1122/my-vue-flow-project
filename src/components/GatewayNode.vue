<script setup lang="ts">
// 這是 src/components/GatewayNode.vue
import { Handle, Position, useNode } from '@vue-flow/core';
import { computed, ref, watch } from 'vue';

interface Path {
  id: string;
  target?: string; // 將 target 設為可選
  condition: string;
}

interface GatewayNodeData {
  modelId: string;
  paths: Path[];
  prompt: string;
}

const { node } = useNode<GatewayNodeData>();

const modelId = ref(node.data.modelId || 'azure-openai-gpt-4o');
const paths = ref<Path[]>(node.data.paths || []);
const prompt = ref(node.data.prompt || '我們可以設定決策條件，然後大語言模型就能根據這些條件來決定對話的發展方向。');


const updateNodeData = () => {
  node.data = {
    ...node.data,
    modelId: modelId.value,
    paths: paths.value,
    prompt: prompt.value,
  };
};

const addPath = () => {
  const newId = `path-${Date.now()}`;
  paths.value.push({
    id: newId,
    condition: `分支 ${paths.value.length + 1} 的條件`,
  });
};

const removePath = (index: number) => {
  paths.value.splice(index, 1);
};

watch(() => node.data.paths, (newPaths) => {
  paths.value = newPaths;
}, { deep: true });

// 計算每個分支的位置
const pathPositions = computed(() => {
  const count = paths.value.length;
  return paths.value.map((_, index) => {
    const percentage = (index + 1) / (count + 1);
    return { x: 100, y: percentage * 100 };
  });
});

watch([modelId, paths, prompt], updateNodeData, { deep: true });
</script>

<template>
  <div class="node gateway-node">
    <Handle type="target" :position="Position.Left" />
    
    <div class="node-header">
      <h3>Gateway</h3>
      <p>根據設定的條件決定流程的分支方向。</p>
    </div>
    
    <div class="node-content">
      <div class="section">
        <h4>模型</h4>
        <select v-model="modelId">
          <option value="azure-openai-gpt-4o">Azure OpenAI GPT-4o</option>
          <option value="anthropic-claude-3-5-sonnet">Claude 3.5 Sonnet</option>
          <option value="gemini-1.5-flash">Gemini 1.5 Flash</option>
        </select>
      </div>
      
      <div class="section">
        <h4>分支</h4>
        <div v-for="(path, index) in paths" :key="path.id" class="path-row">
          <input v-model="path.condition" :placeholder="`分支 ${index + 1} 的條件`">
          <button @click="removePath(index)" class="remove-btn">-</button>
          <Handle 
            type="source" 
            :position="Position.Right" 
            :id="path.id"
            :style="{ top: `${pathPositions[index].y}%` }"
          />
        </div>
        <button @click="addPath" class="add-btn">+ 添加分支</button>
      </div>
      
      <div class="section">
        <h4>決策提示</h4>
        <textarea v-model="prompt" rows="3" placeholder="描述決策的提示"></textarea>
      </div>
    </div>
  </div>
</template>

<style scoped>
.gateway-node {
  background-color: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 5px;
  padding: 10px;
  width: 300px;
  position: relative;
}

.path-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 5px;
  position: relative;
}

.path-row input {
  width: 70%;
}

.remove-btn, .add-btn {
  padding: 2px 5px;
  background-color: #fff;
  border: 1px solid #d9d9d9;
  border-radius: 3px;
  cursor: pointer;
}

.remove-btn:hover, .add-btn:hover {
  background-color: #f0f0f0;
}

textarea {
  width: 100%;
  resize: vertical;
}

.node-content {
  padding-right: 20px; /* 為右側的連接點留出空間 */
}

/* 自定義 Handle 樣式 */
:deep(.vue-flow__handle-right) {
  right: -10px;
  width: 10px;
  height: 10px;
  background-color: #91d5ff;
  border: 2px solid #1890ff;
}
</style>