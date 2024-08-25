<script setup lang="ts">
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
  <div class="node custom-node">
    <Handle type="source" :position="Position.Bottom" />
    
    <div class="node-header">
      <h3>{{ node.data.label }}</h3>
      <p>{{ node.data.description }}</p>
    </div>
    
    <div class="node-content">
      <div class="section">
        <h4>Input</h4>
        <div v-for="(item, index) in inputs" :key="index" class="input-row">
          <input :value="item.name" @input="e => handleInputChange(e, index, 'name')" placeholder="變量名稱" :disabled="item.isBuiltIn" />
          <select :value="item.type" @change="e => handleInputChange(e, index, 'type')" :disabled="item.isBuiltIn">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          <input :value="item.description" @input="e => handleInputChange(e, index, 'description')" placeholder="描述" :disabled="item.isBuiltIn" />
          <label class="checkbox-container">
            <input type="checkbox" :checked="item.required" @change="e => handleInputChange(e, index, 'required')" :disabled="item.isBuiltIn" />
            <span class="checkmark"></span>
          </label>
          <button v-if="!item.isBuiltIn" @click="deleteInput(index)" class="delete-button">-</button>
        </div>
        <button @click="addInput" class="add-button">+ Add</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';
</style>