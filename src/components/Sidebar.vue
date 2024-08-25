<script setup>
const emit = defineEmits(['addNode']);

const addNode = (type) => {
  emit('addNode', type);
};
</script>

<template>
  <aside>
    <div class="description">点击按钮添加新节点</div>

    <div class="buttons">
      <button @click="addNode('start')">添加开始节点</button>
      <button @click="addNode('llm')">添加 LLM 节点</button>
      <button @click="addNode('output')">添加输出节点</button>
    </div>
  </aside>
</template>

<style scoped>
aside {
  position: absolute;
  left: 0;
  top: 0;
  z-index: 4;
  background-color: #f8f8f8;
  padding: 15px;
  border-right: 1px solid #ddd;
}

.description {
  font-size: 14px;
  margin-bottom: 10px;
}

.buttons {
  display: flex;
  flex-direction: column;
}

button {
  margin-bottom: 10px;
  padding: 10px;
  border: 1px solid #1a192b;
  border-radius: 3px;
  cursor: pointer;
  background-color: #fff;
}

button:hover {
  background-color: #f0f0f0;
}
</style>