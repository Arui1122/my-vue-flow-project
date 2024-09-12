<script setup>
import { ref, watch } from 'vue';


const props = defineProps({
  maxCounters: {
    type: Object,
    required: true
  }
});

// 定義一個名為 'addNode' 的自定義事件
// 這個事件將被用來通知父組件添加新節點
const emit = defineEmits(['addNode']);

const counters = ref({ ...props.maxCounters });

watch(() => props.maxCounters, (newValue) => {
  counters.value = { ...newValue };
});

const addNode = (type) => {
  // 確保 counters 中有對應類型的計數器
  if (!(type in counters.value)) {
    counters.value[type] = 0;
  }
  
  counters.value[type]++;
  const formattedCounter = String(counters.value[type]).padStart(3, '0');
  const newNode = {
    id: `${type}-${formattedCounter}`,
    type: type,
    position: { x: Math.random() * 500, y: Math.random() * 500 },
    data: getInitialData(type),
  };
  console.log(`New ${type.toUpperCase()} node added:`, newNode);
  emit('addNode', newNode);
};

const getInitialData = (type) => {
  switch (type) {
    case 'llm':
      return {
        modelId: 'openai-gpt-4o',
        inputs: [],
        prompt: '',
        outputs: [],
      };
    case 'km':
      return {
        knowledge: [''],
        searchStrategy: 'Semantics',
        maxRecalls: 1,
        minMatchingDegree: 0.5,
      };
    case 'gateway':
      return {
        model: 'openai-gpt-4o',
        paths: [],
        description: '我們可以設定決策條件，然後大語言模型就能根據這些條件來決定對話的發展方向。',
      };
    default:
      return {};
  }
};

const addLLMNode = () => addNode('llm');
const addKMNode = () => addNode('km');
const addGatewayNode = () => addNode('gateway');

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