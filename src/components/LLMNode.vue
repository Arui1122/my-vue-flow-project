<script setup lang="ts">
import { Handle, Position, useNode } from '@vue-flow/core';
import { ref, watch } from 'vue';

interface InputParam {
  name: string;
  value: string;
  type: string;
}

interface OutputParam {
  name: string;
  type: string;
  description: string;
}

interface NodeData {
  label: string;
  model: string;
  inputs: InputParam[];
  prompt: string;
  outputs: OutputParam[];
}

const { node } = useNode<NodeData>();

const model = ref(node.data.model || 'GPT-3.5 Turbo');
const inputs = ref<InputParam[]>(node.data.inputs || []);
const prompt = ref(node.data.prompt || '');
const outputs = ref<OutputParam[]>(node.data.outputs || []);

const updateNodeData = () => {
  node.data = {
    ...node.data,
    model: model.value,
    inputs: inputs.value,
    prompt: prompt.value,
    outputs: outputs.value,
  };
};

const addItem = <T>(items: T[], defaultItem: T) => {
  items.push({ ...defaultItem });
};

const removeItem = <T>(items: T[], index: number) => {
  items.splice(index, 1);
};

const addInput = () => addItem(inputs.value, { name: '', value: '', type: 'String' });
const removeInput = (index: number) => removeItem(inputs.value, index);

const addOutput = () => addItem(outputs.value, { name: '', type: 'String', description: '' });
const removeOutput = (index: number) => removeItem(outputs.value, index);

watch([model, inputs, prompt, outputs], updateNodeData, { deep: true });
</script>

<template>
   <div class="node llm-node">
    <Handle type="target" :position="Position.Top" />
    
    <div class="node-header">
      <h3>LLM</h3>
      <p>Invoke the large language model, generate responses using variables and prompt words.</p>
    </div>
    
    <div class="node-content">
      <div class="section">
        <h4>Model</h4>
        <select v-model="model">
          <option value="GPT-3.5 Turbo">GPT-3.5 Turbo</option>
          <option value="GPT-4">GPT-4</option>
        </select>
      </div>
      
      <div class="section">
        <h4>Input</h4>
        <div v-for="(input, index) in inputs" :key="index" class="input-row">
          <input v-model="input.name" placeholder="Parameter name">
          <select v-model="input.type">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          <input v-model="input.value" placeholder="Variable value">
          <button @click="removeInput(index)">-</button>
        </div>
        <button @click="addInput">+ Add</button>
      </div>
      
      <div class="section">
        <h4>Prompt</h4>
        <textarea v-model="prompt" placeholder="User prompt. You can use {{variable name}} to reference variables in input parameters."></textarea>
      </div>
      
      <div class="section">
        <h4>Output</h4>
        <div v-for="(output, index) in outputs" :key="index" class="output-row">
          <input v-model="output.name" placeholder="Variable name">
          <select v-model="output.type">
            <option value="String">String</option>
            <option value="Number">Number</option>
            <option value="Boolean">Boolean</option>
          </select>
          <input v-model="output.description" placeholder="Description">
          <button @click="removeOutput(index)">-</button>
        </div>
        <button @click="addOutput">+ Add</button>
      </div>
    </div>
    
    <Handle type="source" :position="Position.Bottom" />
  </div>
</template>

<style scoped>
@import '../assets/commonStyles.css';
</style>