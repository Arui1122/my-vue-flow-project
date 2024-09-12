<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { ref, watch, computed } from 'vue';

// 定義輸入參數的介面
interface InputParam {
  name: string;
  value: string;
  type: string;
}

// 定義輸出參數的介面
interface OutputParam {
  name: string;
  type: string;
  description: string;
}

interface Function {
  id: string;        // 函數唯一標識符
  name: string;      // 函數名稱
  description: string; // 函數描述
}

// 定義節點數據的介面
interface NodeData {
  modelId: string;
  inputs: InputParam[];
  prompt: string;
  functions: string[]; // 選中的函數ID列表
  outputs: OutputParam[];
}

// 使用 useNode 鉤子獲取節點數據
const { node } = useNode<NodeData>();

// 創建響應式引用來存儲節點數據
const modelId = ref(node.data.modelId || 'openai-gpt-4o');
const inputs = ref<InputParam[]>(node.data.inputs || []);
const prompt = ref(node.data.prompt || '');
const functions = ref<string[]>(node.data.functions || []);
const outputs = ref<OutputParam[]>(node.data.outputs || []);

// 預定義的函數列表
const availableFunctions = computed(() => [
  { id: 'func1', name: '函數1', description: '這是函數1的描述' },
  { id: 'func2', name: '函數2', description: '這是函數2的描述' },
  { id: 'func3', name: '函數3', description: '這是函數3的描述' },
]);

// 更新節點數據的函數
const updateNodeData = () => {
  node.data = {
    ...node.data,
    modelId: modelId.value,
    inputs: inputs.value,
    prompt: prompt.value,
    functions: functions.value,
    outputs: outputs.value,
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

// 添加輸入參數的函數
const addInput = () => addItem(inputs.value, { name: '', value: '', type: 'String' });
// 移除輸入參數的函數
const removeInput = (index: number) => removeItem(inputs.value, index);

// 添加函數的函數
const addFunction = () => {
  if (functions.value.length < availableFunctions.value.length) {
    functions.value.push('');
  }
};

// 移除函數的函數
const removeFunction = (index: number) => {
  functions.value.splice(index, 1);
};

// 添加輸出參數的函數
const addOutput = () => addItem(outputs.value, { name: '', type: 'String', description: '' });
// 移除輸出參數的函數
const removeOutput = (index: number) => removeItem(outputs.value, index);

// 監聽數據變化並更新節點
watch([modelId, inputs, prompt, functions, outputs], updateNodeData, { deep: true });
</script>

<template>
  <div class="node llm-node">
    <!-- 頂部連接點 -->
    <Handle type="target" :position="Position.Left" />

    <!-- 節點標題和描述 -->
    <div class="node-header">
      <h3>LLM ({{ node.id }}) </h3>
      <p>呼叫大型語言模型，使用變量和提示詞生成回應。</p>
    </div>

    <!-- 節點內容 -->
    <div class="node-content">
      <!-- 模型選擇部分 -->
      <div class="section">
        <h4>
          <label for="model-select">模型</label>
        </h4>
        <select id="model-select" v-model="modelId">
          <option value="azure-openai-gpt-4o">Azure OpenAI GPT-4o</option>
          <option value="anthropic-claude-3-5-sonnet">Claude 3.5 Sonnet</option>
          <option value="gemini-1.5-flash">Gemini 1.5 Flash</option>
          <option value="openai-gpt-4o">OpenAI GPT-4o</option>
        </select>
      </div>

      <!-- 輸入參數部分 -->
      <div class="section">
        <h4>輸入</h4>
        <div v-for="(input, index) in inputs" :key="index" class="input-row">
          <input :id="`input-name-${index}`" v-model="input.name" placeholder="參數名稱">
          <select :id="`input-type-${index}`" v-model="input.type">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          <input :id="`input-value-${index}`" v-model="input.value" placeholder="變量值">
          <button @click="removeInput(index)" aria-label="移除輸入參數">-</button>
        </div>
        <button @click="addInput">+ 新增輸入</button>
      </div>

      <!-- 提示詞部分 -->
      <div class="section">
        <h4>
          <label for="prompt-textarea">提示詞</label>
        </h4>
        <textarea id="prompt-textarea" v-model="prompt" placeholder="用戶提示。您可以使用 {{變量名}} 來引用輸入參數中的變量。"></textarea>
      </div>

      <!-- 函數選擇部分 -->
      <div class="section">
        <h4>函數</h4>
        <div v-for="(func, index) in functions" :key="index" class="function-row">
          <select v-model="functions[index]">
            <option value="">請選擇函數</option>
            <option v-for="availableFunc in availableFunctions" :key="availableFunc.id" :value="availableFunc.id">
              {{ availableFunc.name }} - {{ availableFunc.name }}
            </option>
          </select>
          <button @click="removeFunction(index)" aria-label="移除函數">-</button>
        </div>
        <button @click="addFunction" :disabled="functions.length >= availableFunctions.length">+ 新增函數</button>
      </div>

      <!-- 輸出參數部分 -->
      <div class="section">
        <h4>輸出</h4>
        <div v-for="(output, index) in outputs" :key="index" class="output-row">
          <input :id="`output-name-${index}`" v-model="output.name" placeholder="變量名稱">
          <select :id="`output-type-${index}`" v-model="output.type">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          <input :id="`output-description-${index}`" v-model="output.description" placeholder="描述">
          <button @click="removeOutput(index)" aria-label="移除輸出參數">-</button>
        </div>
        <button @click="addOutput">+ 新增輸出</button>
      </div>
    </div>

    <!-- 底部連接點 -->
    <Handle type="source" :position="Position.Right" />
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';

.function-row {
  display: flex;
  align-items: center;
  margin-bottom: 5px;
}

.function-row select {
  flex-grow: 1;
  margin-right: 5px;
}
</style>