<a href="https://idx.google.com/import?url=https%3A%2F%2Fgithub.com%2Fsamzhu%2Fmy-vue-flow-project">
  <img
    height="32"
    alt="Open in IDX"
    src="https://cdn.idx.dev/btn/open_light_32.svg">
</a>

# Vue 3 + Vite


This template should help get you started developing with Vue 3 in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

Learn more about IDE Support for Vue in the [Vue Docs Scaling up Guide](https://vuejs.org/guide/scaling-up/tooling.html#ide-support).

## Vue Flow

https://vueflow.dev/

``` bash
npm create vite@latest my-vue-flow-project -- --template vue

cd my-vue-flow-project

npm add @vue-flow/core

npm run dev -- --host 0.0.0.0
```


在 App.vue 中導入 LLMNode：

``` js
import LLMNode from './components/LLMNode.vue';
```

在 nodeTypes 中添加 LLMNode：
``` js
const nodeTypes = {
  customStart: markRaw(CustomStartNode),
  llm: markRaw(LLMNode),
};
```

在 nodes 數組中添加一個新的 LLM 節點：
``` js
const nodes = ref([
  // ... 其他節點
  { 
    id: '4',
    type: 'llm', 
    position: { x: 250, y: 200 },
    data: { 
      label: 'LLM Node',
      model: 'GPT-3.5 Turbo',
      inputs: [],
      prompt: '',
      outputs: [],
    },
  },
]);
```

npm install @vue-flow/minimap
npm install @vue-flow/controls
npm install @vue-flow/background

npm install vue-router@4