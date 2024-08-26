<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { computed } from 'vue';

// 定義輸入項的介面
interface InputItem {
  name: string;
  type: 'String' | 'Number' | 'Boolean';
  description: string;
  required: boolean;
  isBuiltIn: boolean;
}

// 定義節點數據的介面
interface NodeData {
  label: string;
  description: string;
  inputs: InputItem[];
}

// 使用 useNode 鉤子獲取節點數據
const { node } = useNode<NodeData>();

// 創建一個計算屬性來處理輸入項
const inputs = computed({
  get: () => node.data.inputs,
  set: (newInputs) => {
    node.data = {
      ...node.data,
      inputs: newInputs
    };
  }
});

// 添加新輸入項的函數
const addInput = () => {
  const newInput: InputItem = {
    name: `新輸入${inputs.value.length + 1}`,
    type: 'String',
    description: '請輸入描述',
    required: false,
    isBuiltIn: false
  };
  inputs.value = [...inputs.value, newInput];
};

// 刪除輸入項的函數
const deleteInput = (index: number) => {
  const newInputs = [...inputs.value];
  newInputs.splice(index, 1);
  inputs.value = newInputs;
};

// 更新輸入項的函數
const updateInput = (index: number, field: keyof InputItem, value: any) => {
  const newInputs = [...inputs.value];
  newInputs[index] = { ...newInputs[index], [field]: value };
  inputs.value = newInputs;
};

// 處理輸入變化的函數
const handleInputChange = (e: Event, index: number, field: keyof InputItem) => {
  const target = e.target as HTMLInputElement | HTMLSelectElement;
  let value: string | boolean;

  if (field === 'required') {
    value = (target as HTMLInputElement).checked;
  } else if (field === 'type') {
    value = (target as HTMLSelectElement).value as 'String' | 'Number' | 'Boolean';
  } else {
    value = target.value;
  }

  updateInput(index, field, value);
};
</script>

<template>
  <div class="node custom-node">
    <!-- 底部連接點 -->
    <Handle type="source" :position="Position.Bottom" />
    
    <!-- 節點標題和描述 -->
    <div class="node-header">
      <h3>{{ node.data.label }}</h3>
      <p>{{ node.data.description }}</p>
    </div>
    
    <!-- 節點內容 -->
    <div class="node-content">
      <div class="section">
        <h4>Input</h4>
        <!-- 遍歷輸入項 -->
        <div v-for="(item, index) in inputs" :key="index" class="input-row">
          <!-- 變量名稱輸入框 -->
          <input :id="`name-${index}`" :value="item.name" @input="e => handleInputChange(e, index, 'name')" placeholder="變量名稱" :disabled="item.isBuiltIn" />
          
          <!-- 類型選擇框 -->
          <select :id="`type-${index}`" :value="item.type" @change="e => handleInputChange(e, index, 'type')" :disabled="item.isBuiltIn">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          
          <!-- 描述輸入框 -->
          <input :id="`description-${index}`" :value="item.description" @input="e => handleInputChange(e, index, 'description')" placeholder="描述" :disabled="item.isBuiltIn" />
          
          <!-- 必填選項 -->
          <label :for="`required-${index}`" class="checkbox-container">
            <input :id="`required-${index}`" type="checkbox" :checked="item.required" @change="e => handleInputChange(e, index, 'required')" :disabled="item.isBuiltIn" />
            <span class="checkmark"></span>
          </label>
          
          <!-- 刪除按鈕（僅對非內建輸入項顯示） -->
          <button v-if="!item.isBuiltIn" @click="deleteInput(index)" class="delete-button">-</button>
        </div>
        <!-- 添加新輸入項按鈕 -->
        <button @click="addInput" class="add-button">+ Add</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';
</style>