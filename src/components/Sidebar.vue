<script setup>
// 定義一個名為 'addNode' 的自定義事件
// 這個事件將被用來通知父組件添加新節點
const emit = defineEmits(['addNode']);

// 定義一個函數，當用戶點擊按鈕時調用
// 這個函數接受一個參數 'type'，表示要添加的節點類型
const addNode = (type) => {
  // 觸發 'addNode' 事件，並將節點類型作為參數傳遞給父組件
  emit('addNode', type);
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
      <button @click="addNode('start')">添加開始節點</button>

      <!-- 添加 LLM (語言模型) 節點的按鈕 -->
      <button @click="addNode('llm')">添加 LLM 節點</button>

      <!-- 添加輸出節點的按鈕 -->
      <button @click="addNode('output')">添加輸出節點</button>
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
  font-size: 14px; /* 字體大小 */
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