<script setup>
// 導入所需的組件和函數
import { ref, watch } from 'vue';
import { Panel, useVueFlow } from '@vue-flow/core';

// 定義 props
const props = defineProps({
  flowId: {
    type: String,
    default: null
  }
});

// 定義一個用於 localStorage 的鍵名
// const flowKey = 'vue-flow--save-restore'

// 從 useVueFlow 鉤子中獲取所需的函數和狀態
const { nodes, edges, addNodes, toObject, fromObject } = useVueFlow()

// 使用 ref 來跟踪 flowId
const currentFlowId = ref(props.flowId);

// 監聽 props 中 flowId 的變化
watch(() => props.flowId, (newFlowId) => {
  currentFlowId.value = newFlowId;
});



// 保存圖表到 localStorage 的函數
async function onSave() {
  const flowObject = toObject();
  console.log('準備保存的圖表數據：', flowObject);
  const url = currentFlowId.value
    ? `http://localhost:8080/workflows/${currentFlowId.value}`
    : 'http://localhost:8080/workflows';

  const method = currentFlowId.value ? 'PUT' : 'POST';
  // var data = JSON.stringify(flowObject);
  console.log(`保存的資料: ${JSON.stringify(flowObject)}`);
  try {
    const response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(flowObject),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    console.log(`保存成功: ${response.statusText}`);

    // 如果是新建的工作流，從響應中獲取新的 flowId
    if (!currentFlowId.value && response.headers.get("Location")) {
      const newFlowId = response.headers.get("Location").split("/").pop();
      currentFlowId.value = newFlowId;
      console.log(`新的 flowId: ${newFlowId}`);
      // 這裡可以添加更新 URL 的邏輯，如果需要的話
    }

  } catch (error) {
    console.error('保存失敗：', error);
  }
}

// 從 localStorage 恢復圖表的函數
function onRestore() {
  // 從 localStorage 獲取保存的圖表數據
  // const flow = JSON.parse(localStorage.getItem(flowKey))
  // 如果找到保存的數據
  // if (flow) {
  //   // 使用保存的數據重建圖表
  //   fromObject(flow)
  // }
}

// 添加隨機節點的函數
function onAddRandomNode() {
  // 創建一個新的隨機節點
  const newNode = {
    // 使用時間戳作為唯一 ID
    id: `random-${Date.now()}`,
    // 隨機選擇節點類型（開始節點或 LLM 節點）
    type: Math.random() > 0.5 ? 'start' : 'llm',
    // 隨機設置節點位置
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    // 設置節點標籤
    data: { label: `隨機節點 ${nodes.value.length + 1}` },
  }
  // 將新節點添加到圖表中
  addNodes([newNode])
}
</script>

<template>
  <!-- 創建一個位於右上角的控制面板 -->
  <Panel position="top-right" class="save-restore-controls">
    <!-- 保存圖表按鈕 -->
    <button title="保存圖表" @click="onSave">💾</button>
    <!-- 恢復圖表按鈕 -->
    <button title="恢復圖表" @click="onRestore">📂</button>
    <!-- 添加隨機節點按鈕 -->
    <button title="添加隨機節點" @click="onAddRandomNode">➕</button>
  </Panel>
</template>

<style scoped>
/* 控制面板的樣式 */
.save-restore-controls {
  display: flex;
  /* 使用 flex 佈局 */
  gap: 5px;
  /* 按鈕之間的間距 */
}

/* 按鈕的樣式 */
button {
  background-color: #4a5568;
  /* 深灰色背景 */
  color: white;
  /* 白色文字 */
  border: none;
  /* 無邊框 */
  padding: 5px 10px;
  /* 內部留白 */
  border-radius: 4px;
  /* 圓角 */
  cursor: pointer;
  /* 滑鼠指針變為手型 */
  font-size: 16px;
  /* 字體大小 */
}

/* 滑鼠懸停在按鈕上時的樣式 */
button:hover {
  background-color: #2d3748;
  /* 更深的灰色 */
}

/* VueFlow 面板的樣式 */
.vue-flow__panel {
  background-color: #b4c6f9;
  /* 淺藍色背景 */
  padding: 5px;
  /* 內部留白 */
  border-radius: 4px;
  /* 圓角 */
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  /* 陰影效果 */
}
</style>