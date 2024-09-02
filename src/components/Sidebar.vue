<script setup>
// 這是 src/components/Sidebar.vue
// 定義一個名為 'addNode' 的自定義事件
// 這個事件將被用來通知父組件添加新節點
const emit = defineEmits(['addNode']);

// 定義一個函數，當用戶點擊按鈕時調用
// 這個函數接受一個參數 'type'，表示要添加的節點類型
const addNode = (type) => {
  // 觸發 'addNode' 事件，並將節點類型作為參數傳遞給父組件
  emit('addNode', type);
};

const addLLMNode = () => {
  console.log('side New node added:');
  const newNode = {
    id: `llm-${Date.now()}`,
    type: 'llm',
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    data: {
      label: 'LLM Node',
      model: 'GPT-3.5 Turbo',
      inputs: [],
      prompt: '',
      outputs: [],
    },
  };
  emit('addNode', newNode);
};

const addKMNode = () => {
  console.log('side New KM node added:');
  const newNode = {
    id: `km-${Date.now()}`,
    type: 'km',
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    data: {
      label: 'Knowledge Management',
      reference: 'Reference',
      query: '',
      knowledge: ['test'],
      searchStrategy: 'Semantics',
      maxRecalls: 1,
      minMatchingDegree: 0.5,
    },
  };
  emit('addNode', newNode);
};

const addGatewayNode = () => {
  console.log('New Gateway node added:');
  const newNode = {
    id: `gateway-${Date.now()}`,
    type: 'gateway',
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    data: {
      label: 'Gateway Node',
      model: 'gpt-3.5-turbo',
      paths: [],
      description: '我们可以设定分支条件，然后大语言模型就能根据这些条件来决定对话的发展方向。',
    },
  };
  emit('addNode', newNode);
};


</script>

<template>
  <!-- 創建一個側邊欄 -->
  <aside>
    <!-- 顯示說明文字 -->
    <div class="description">點擊按鈕添加新節點</div>

    <!-- 包含所有按鈕的容器 -->
    <div class="buttons">
      <!-- 添加開始節點的按鈕 -->
      <!-- 當點擊時，調用 addNode 函數並傳入 'start' 作為參數 -->
      <!-- <button @click="addNode('start')">添加開始節點</button> -->

      <!-- 添加 LLM (語言模型) 節點的按鈕 -->
      <button @click="addLLMNode">添加 LLM 節點</button>
      <button @click="addKMNode">添加 KM 節點</button>
      <button @click="addGatewayNode">添加決策節點</button>

    </div>
  </aside>
</template>

<style scoped>
/* 側邊欄的樣式 */
aside {
  position: absolute; /* 絕對定位 */
  left: 0; /* 靠左對齊 */
  top: 0; /* 靠上對齊 */
  z-index: 4; /* 確保側邊欄顯示在其他元素之上 */
  background-color: #f8f8f8; /* 淺灰色背景 */
  padding: 15px; /* 內邊距 */
  border-right: 1px solid #ddd; /* 右邊框 */
}

/* 說明文字的樣式 */
.description {
  font-size: 12px; /* 字體大小 */
  margin-bottom: 10px; /* 下方留白 */
}

/* 按鈕容器的樣式 */
.buttons {
  display: flex; /* 使用 flex 佈局 */
  flex-direction: column; /* 按鈕垂直排列 */
}

/* 按鈕的樣式 */
button {
  margin-bottom: 10px; /* 按鈕之間的間距 */
  padding: 10px; /* 按鈕內部留白 */
  border: 1px solid #1a192b; /* 邊框 */
  border-radius: 3px; /* 圓角 */
  cursor: pointer; /* 滑鼠指針變為手型 */
  background-color: #fff; /* 白色背景 */
}

/* 滑鼠懸停在按鈕上時的樣式 */
button:hover {
  background-color: #f0f0f0; /* 滑鼠懸停時變為淺灰色 */
}
</style>