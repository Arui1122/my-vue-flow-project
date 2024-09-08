<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { ref, watch } from 'vue';

// 定義輸出參數的介面
interface OutputParam {
  name: string;
  type: string;
  value: string;
}

// 定義節點數據的介面
interface NodeData {
  label: string;
  responseMode: string;
  outputVariables: OutputParam[];
  response: string;
  streamingOutput: boolean;
}

// 使用 useNode 鉤子獲取節點數據
const { node } = useNode<NodeData>();

// 創建響應式引用來存儲節點數據
const responseMode = ref(node.data.responseMode || 'direct');
const outputVariables = ref<OutputParam[]>(node.data.outputVariables || []);
const response = ref(node.data.response || '');
const streamingOutput = ref(node.data.streamingOutput || false);

// 更新節點數據的函數
const updateNodeData = () => {
  node.data = {
    ...node.data,
    responseMode: responseMode.value,
    outputVariables: outputVariables.value,
    response: response.value,
    streamingOutput: streamingOutput.value,
  };
};

// 通用添加項目的函數
const addItem = <T>(items: T[], defaultItem: T) => {
  items.push({ ...defaultItem });
};

// 通用移除項目的函數
const removeItem = <T>(items: T[], index: number) => {
  items.splice(index, 1);
};

// 添加輸出變量的函數
const addOutputVariable = () => addItem(outputVariables.value, { name: '', type: 'String', value: '' });
// 移除輸出變量的函數
const removeOutputVariable = (index: number) => removeItem(outputVariables.value, index);

// 監聽數據變化並更新節點
watch([responseMode, outputVariables, response, streamingOutput], updateNodeData, { deep: true });
</script>

<template>
  <div class="node end-node">
    <!-- 頂部連接點 -->
    <Handle type="target" :position="Position.Left" />

    <!-- 節點標題和描述 -->
    <div class="node-header">
      <h3>End</h3>
      <p>工作流的最終節點，用於返回工作流運行後的結果信息。</p>
    </div>

    <!-- 節點內容 -->
    <div class="node-content">
      <!-- 響應模式選擇部分 -->
      <div class="section">
        <h4>
          <label for="response-mode-select">選擇響應模式</label>
        </h4>
        <select id="response-mode-select" v-model="responseMode">
          <option value="direct">直接使用回答內容</option>
          <option value="template">使用響應模板</option>
        </select>
      </div>

      <!-- 輸出變量部分 -->
      <div class="section">
        <h4>輸出變量</h4>
        <div v-for="(variable, index) in outputVariables" :key="index" class="output-row">
          <input :id="`output-name-${index}`" v-model="variable.name" placeholder="參數名稱">
          <select :id="`output-type-${index}`" v-model="variable.type">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          <input :id="`output-value-${index}`" v-model="variable.value" placeholder="變量值">
          <button @click="removeOutputVariable(index)" aria-label="移除輸出變量">-</button>
        </div>
        <button @click="addOutputVariable">+ 新增輸出變量</button>
      </div>

      <!-- 響應內容部分 -->
      <div class="section">
        <h4>
          <label for="response-textarea">響應</label>
        </h4>
        <textarea id="response-textarea" v-model="response" placeholder="輸入您的響應內容。使用 {{變量名}} 來引用輸出變量。"></textarea>
      </div>

      <!-- 流式輸出選項 -->
      <div class="section">
        <label for="streaming-output-checkbox" class="checkbox-label">
          <input type="checkbox" id="streaming-output-checkbox" v-model="streamingOutput">
          流式輸出
        </label>
      </div>
    </div>

    <!-- 底部連接點 -->
    <!-- <Handle type="source" :position="Position.Left" /> -->
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';

/* .end-node {
  background-color: #e4e3e3;
  border: 1px solid #e0e0e0;
} */

/* .checkbox-label {
  display: flex;
  align-items: center;
  gap: 5px;
} */
</style>