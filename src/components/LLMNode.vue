<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { ref, watch } from 'vue';

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

// 定義節點數據的介面
interface NodeData {
  label: string;
  model: string;
  inputs: InputParam[];
  prompt: string;
  outputs: OutputParam[];
}

// 使用 useNode 鉤子獲取節點數據
const { node } = useNode<NodeData>();

// 創建響應式引用來存儲節點數據
const model = ref(node.data.model || 'GPT-3.5 Turbo');
const inputs = ref<InputParam[]>(node.data.inputs || []);
const prompt = ref(node.data.prompt || '');
const outputs = ref<OutputParam[]>(node.data.outputs || []);

// 更新節點數據的函數
const updateNodeData = () => {
  node.data = {
    ...node.data,
    model: model.value,
    inputs: inputs.value,
    prompt: prompt.value,
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

// 添加輸出參數的函數
const addOutput = () => addItem(outputs.value, { name: '', type: 'String', description: '' });
// 移除輸出參數的函數
const removeOutput = (index: number) => removeItem(outputs.value, index);

// 監聽數據變化並更新節點
watch([model, inputs, prompt, outputs], updateNodeData, { deep: true });
</script>

<template>
  <div class="node llm-node">
    <!-- 頂部連接點 -->
    <Handle type="target" :position="Position.Top" />
    
    <!-- 節點標題和描述 -->
    <div class="node-header">
      <h3>LLM</h3>
      <p>呼叫大型語言模型，使用變量和提示詞生成回應。</p>
    </div>
    
    <!-- 節點內容 -->
    <div class="node-content">
      <!-- 模型選擇部分 -->
      <div class="section">
        <h4>
          <label for="model-select">模型</label>
        </h4>
        <select id="model-select" v-model="model">
          <option value="GPT-3.5 Turbo">GPT-3.5 Turbo</option>
          <option value="GPT-4">GPT-4</option>
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
    <Handle type="source" :position="Position.Bottom" />
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';
</style>