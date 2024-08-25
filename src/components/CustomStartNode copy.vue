<script setup lang="ts">
// Script 部分保持不變
import { Handle, Position, useNode } from '@vue-flow/core';
import { computed } from 'vue';

interface InputItem {
  name: string;
  type: 'String' | 'Number' | 'Boolean';
  description: string;
  required: boolean;
  isBuiltIn: boolean;
}

interface NodeData {
  label: string;
  description: string;
  inputs: InputItem[];
}

const { node } = useNode<NodeData>();

const inputs = computed({
  get: () => node.data.inputs,
  set: (newInputs) => {
    node.data = {
      ...node.data,
      inputs: newInputs
    };
  }
});

const addNewInput = () => {
  const newInput: InputItem = {
    name: `新輸入${inputs.value.length + 1}`,
    type: 'String',
    description: '請輸入描述',
    required: false,
    isBuiltIn: false
  };
  inputs.value = [...inputs.value, newInput];
};

const deleteInput = (index: number) => {
  const newInputs = [...inputs.value];
  newInputs.splice(index, 1);
  inputs.value = newInputs;
};

const updateInput = (index: number, field: keyof InputItem, value: any) => {
  const newInputs = [...inputs.value];
  newInputs[index] = { ...newInputs[index], [field]: value };
  inputs.value = newInputs;
};

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
  <div class="custom-node">
    <Handle type="source" :position="Position.Bottom" />
    
    <div class="custom-node__header">
      <div class="custom-node__title">
        <span class="icon">▶</span>
        {{ node.data.label }}
      </div>
      <div class="custom-node__description">
        {{ node.data.description }}
      </div>
    </div>
    
    <div class="custom-node__body">
      <div class="custom-node__section">
        <div class="custom-node__section-title">
          <span class="icon">▼</span>
          輸入
        </div>
        <div class="custom-node__table-wrapper nowheel">
          <table class="custom-node__table">
            <thead>
              <tr>
                <th>變量名稱</th>
                <th>變量類型</th>
                <th>描述</th>
                <th>必填</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in inputs" :key="index">
                <td><input :value="item.name" @input="e => handleInputChange(e, index, 'name')" :disabled="item.isBuiltIn" /></td>
                <td>
                  <select :value="item.type" @change="e => handleInputChange(e, index, 'type')" :disabled="item.isBuiltIn">
                    <option value="String">String</option>
                    <option value="Number">Number</option>
                    <option value="Boolean">Boolean</option>
                  </select>
                </td>
                <td><input :value="item.description" @input="e => handleInputChange(e, index, 'description')" :disabled="item.isBuiltIn" /></td>
                <td>
                  <input type="checkbox" :checked="item.required" @change="e => handleInputChange(e, index, 'required')" :disabled="item.isBuiltIn" />
                </td>
                <td>
                  <button v-if="!item.isBuiltIn" @click="deleteInput(index)" class="delete-button">刪除</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <button class="add-button" @click="addNewInput">
          <span class="icon">+</span>
          新增
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.custom-node {
  background: white;
  border: 1px solid #ddd;
  border-radius: 3px;
  padding: 10px;
  width: 600px; /* 進一步增加節點寬度 */
  display: flex;
  flex-direction: column;
}

.custom-node__header {
  margin-bottom: 10px;
}

.custom-node__title {
  font-weight: bold;
  display: flex;
  align-items: center;
}

.custom-node__description {
  font-size: 0.9em;
  color: #666;
}

.custom-node__body {
  display: flex;
  flex-direction: column;
}

.custom-node__section-title {
  font-weight: bold;
  margin-bottom: 5px;
  display: flex;
  align-items: center;
}

.custom-node__table-wrapper {
  overflow-y: auto;
  max-height: calc(2 * 6em); /* 兩行的高度 */
  margin-bottom: 10px;
}

.custom-node__table {
  width: 100%;
  border-collapse: collapse;
}

.custom-node__table th,
.custom-node__table td {
  border: 1px solid #ddd;
  padding: 5px;
  font-size: 0.8em;
}

.custom-node__table tr {
  height: 3em;
}

.icon {
  margin-right: 5px;
}

.add-button, .delete-button {
  background: none;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
}

.add-button {
  color: blue;
}

.delete-button {
  color: red;
}

input, select {
  width: 90%;
  padding: 2px;
  font-size: 0.8em;
}
</style>