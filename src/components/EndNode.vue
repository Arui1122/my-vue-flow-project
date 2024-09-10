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
  responseMode: string;
  response: string;
  streamingOutput: boolean;
}

// 使用 useNode 鉤子獲取節點數據
const { node } = useNode<NodeData>();

// 創建響應式引用來存儲節點數據
const responseMode = ref(node.data.responseMode || 'direct');
const response = ref(node.data.response || '');
const streamingOutput = ref(node.data.streamingOutput || false);

// 更新節點數據的函數
const updateNodeData = () => {
  node.data = {
    ...node.data,
    responseMode: responseMode.value,
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

// 監聽數據變化並更新節點
watch([responseMode, response, streamingOutput], updateNodeData, { deep: true });
</script>

<template>
  <div class="node end-node">
    <!-- 頂部連接點 -->
    <Handle type="target" :position="Position.Left" />

    <!-- 節點標題和描述 -->
    <div class="node-header">
      <h3>End</h3>
      <p>工作流的最終節點，用於回覆工作流執行後的結果信息。</p>
    </div>

    <!-- 節點內容 -->
    <div class="node-content">

      <!-- 響應內容部分 -->
      <div class="section">
        <h4>
          <label for="response-textarea">回應</label>
        </h4>
        <textarea id="response-textarea" v-model="response" placeholder="輸入您的回應內容。使用 {{變數名}} 來引用輸出變量。"></textarea>
      </div>

      <!-- 流式輸出選項 -->
      <div class="section">
        <label for="streaming-output-checkbox" class="checkbox-label">
          <input type="checkbox" id="streaming-output-checkbox" v-model="streamingOutput">
          支援流式輸出
        </label>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';
</style>