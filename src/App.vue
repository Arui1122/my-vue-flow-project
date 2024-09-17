<script setup>
// 導入必要的組件和函數
import { Background } from '@vue-flow/background';
import { Controls } from '@vue-flow/controls';
import { MarkerType, VueFlow, useVueFlow } from '@vue-flow/core';
import { MiniMap } from '@vue-flow/minimap';
import { markRaw, onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';

// 導入自定義節點組件
import EndNode from './components/EndNode.vue';
import GatewayNode from './components/GatewayNode.vue';
import KMNode from './components/KMNode.vue';
import LLMNode from './components/LLMNode.vue';
import SaveRestoreControls from './components/SaveRestoreControls.vue';
import Sidebar from './components/Sidebar.vue';
import StartNode from './components/StartNode.vue';

// 導入控制面板樣式
import '@vue-flow/controls/dist/style.css';
import '@vue-flow/minimap/dist/style.css';

// 獲取當前路由
const route = useRoute();
const workflowId = ref(route.params.workflowId);

// 定義自定義節點類型
const nodeTypes = {
  start: markRaw(StartNode),
  llm: markRaw(LLMNode),
  km: markRaw(KMNode),
  gateway: markRaw(GatewayNode),
  end: markRaw(EndNode),
};

// 新增：計算各類型節點最大流水號的函數
const calculateMaxCounters = () => {
  const counters = {
    llm: 0,
    km: 0,
    gateway: 0
    // 可以根據需要添加其他節點類型
  };

  nodes.value.forEach(node => {
    if (node.type === 'start' || node.type === 'end') {
      return; // 跳過 start 和 end 節點
    }

    const match = node.id.match(/(\w+)-(\d{3})/);
    if (match) {
      const [, type, numStr] = match;
      if (type in counters) {
        counters[type] = Math.max(counters[type], parseInt(numStr, 10));
      }
    }
  });

  return counters;
};

// 新增：最大流水號的響應式引用
const maxCounters = ref({
  llm: 0,
  km: 0,
  gateway: 0
});

// 預設節點
const defaultNodes = [
  {
    id: 'start',
    type: 'start',
    position: { x: 50, y: 500 },
    data: {
      inputs: [
        { name: 'user_query', type: 'String', value: '', description: '用戶輸入的訊息', required: true, isBuiltIn: true },
        { name: 'sys_info', type: 'String', value: '系統提示', description: '系統提示', required: false, isBuiltIn: false },
      ]
    },
  },
  {
    id: 'end',
    type: 'end',
    position: { x: 1500, y: 500 },
    data: {
      response: '',
      streamingOutput: true,
    },
  },
];

// 預設邊
const defaultEdges = [];

// 創建響應式引用
const nodes = ref(defaultNodes);
const edges = ref(defaultEdges);

// 從 API 獲取流程數據的函數
const fetchFlowData = async (workflowId) => {
  console.log('開始獲取流程數據, workflowId:', workflowId);
  if (workflowId) {
    // flowId = '66dfc2358d08f42b113ddd45';
    try {
      console.log('從 API 獲取數據...');
      const response = await fetch(`http://localhost:8080/workflow/${workflowId}`);

      if (!response.ok) {
        throw new Error(`HTTP 錯誤! 狀態: ${response.status}`);
      }

      const data = await response.json();
      console.log('API 響應:', data);

      if (data && data.nodes && data.nodes.length > 0) {
        console.log('使用 API 數據');
        // 確保每個節點都有一個唯一的 id
        const processedNodes = data.nodes.map((node, index) => ({
          ...node,
          id: node.id || `node-${index}`,
          // 確保 position 是一個對象
          position: typeof node.position === 'object' ? node.position : { x: 0, y: 0 }
        }));
        nodes.value = processedNodes;
        edges.value = data.edges || [];
      } else {
        console.log('API 返回空數據，使用默認數據');
        nodes.value = defaultNodes;
        edges.value = defaultEdges;
      }
    } catch (error) {
      console.error('獲取流程數據時出錯:', error);
      console.log('API 請求失敗，使用默認數據');
      nodes.value = defaultNodes;
      edges.value = defaultEdges;
    }
  } else {
    console.log('未提供 flowId，使用默認數據');
    nodes.value = defaultNodes;
    edges.value = defaultEdges;
  }

  console.log('設置節點和邊');
  console.log('節點:', nodes.value);
  console.log('邊:', edges.value);

  // 使用 Vue Flow 的方法設置節點和邊
  setNodes(nodes.value);
  setEdges(edges.value);

  // 計算並設置最大流水號
  maxCounters.value = calculateMaxCounters();
  console.log('最大流水號:', maxCounters.value);
};

// 組件掛載時執行
onMounted(() => {
  console.log('組件已掛載');
  const flowId = route.params.flowId;
  console.log('Flow ID:', flowId);
  fetchFlowData(flowId);
});

// 監聽路由參數變化
watch(
  () => route.params.workflowId,
  async (newWorkflowId) => {
    console.log('Flow ID 已變更:', newWorkflowId);
    workflowId.value = newWorkflowId;
    fetchFlowData(newWorkflowId);
  }
);

// 使用 VueFlow 鉤子
const { onConnect, addNodes, addEdges, setNodes, setEdges, findNode, onEdgesChange } = useVueFlow();

// 處理節點連接
onConnect((params) => {
  console.log('節點連接:', params);
  // 當用戶手動連接兩個節點時，創建一個新的邊
  const newEdge = {
    id: `e${params.source}-${params.target}`,
    source: params.source,
    target: params.target,
    animated: true,
    markerEnd: {
      type: MarkerType.ArrowClosed,
      width: 30,
      height: 30,
    },
  };
  edges.value.push(newEdge);

  // 更新 gateway 節點的 paths
  const sourceNode = findNode(params.source);
  const targetNode = findNode(params.target);

  if (sourceNode && sourceNode.type === 'gateway' && targetNode) {
    nodes.value = nodes.value.map(node => {
      if (node.id === sourceNode.id) {
        const paths = Array.isArray(node.data.paths) ? node.data.paths : [];
        const existingPathIndex = paths.findIndex(path => path.id === params.sourceHandle);
        if (existingPathIndex !== -1) {
          // 更新現有路徑
          paths[existingPathIndex] = {
            ...paths[existingPathIndex],
            target: targetNode.id,
          };
        } else {
          // 添加新路徑
          paths.push({
            id: params.sourceHandle || `path-${Date.now()}`,
            target: targetNode.id,
            condition: `通向 ${targetNode.data.label || targetNode.type} 的條件`,
          });
        }
        return {
          ...node,
          data: {
            ...node.data,
            paths
          }
        };
      }
      return node;
    });

    setNodes(nodes.value);
  }

  console.log('更新後的節點:', nodes.value);
  console.log('更新後的邊:', edges.value);
});

onEdgesChange((changes) => {
  handleEdgesChange(changes);
});

function handleEdgesChange(changes) {
  changes.forEach(change => {
    if (change.type === 'remove') {
      updateGatewayNodes(change.id);
    } else if (change.type === 'replace') {
      updateGatewayNodesOnEdgeReplace(change);
    }
  });
}

function updateGatewayNodes(removedEdgeId) {
  const updatedNodes = nodes.value.map(node => {
    if (node.type === 'gateway') {
      const updatedPaths = node.data.paths.map(path => {
        if (path.target && isTargetOfRemovedEdge(removedEdgeId, path.target)) {
          // 清除或更新 target
          return { ...path, target: undefined };
        }
        return path;
      });
      return { ...node, data: { ...node.data, paths: updatedPaths } };
    }
    return node;
  });
  
  setNodes(updatedNodes);
}

function updateGatewayNodesOnEdgeReplace(change) {
  const oldEdge = edges.value.find(e => e.id === change.id);
  const newEdge = change.edge;
  
  if (oldEdge && newEdge && oldEdge.target !== newEdge.target) {
    // 更新所有指向旧目标的 gateway 节点
    updateGatewayNodes(oldEdge.id);
    
    // 更新所有指向新目标的 gateway 节点
    const updatedNodes = nodes.value.map(node => {
      if (node.type === 'gateway') {
        const updatedPaths = node.data.paths.map(path => {
          if (path.id === newEdge.sourceHandle) {
            return { ...path, target: newEdge.target };
          }
          return path;
        });
        return { ...node, data: { ...node.data, paths: updatedPaths } };
      }
      return node;
    });
    
    setNodes(updatedNodes);
  }
}

function isTargetOfRemovedEdge(edgeId, targetId) {
  const edge = edges.value.find(e => e.id === edgeId);
  return edge && edge.target === targetId;
}


// 處理添加新節點
const onNodeAdded = (newNode) => {
  console.log('新增節點:', newNode);
  addNodes([newNode]);
  // 更新最大流水號
  maxCounters.value = calculateMaxCounters();
};

// 縮放和交互變化的處理函數
const onZoomIn = () => console.log('放大');
const onZoomOut = () => console.log('縮小');
const onFitView = () => console.log('適應視圖');
const onInteractionChange = (interactionEnabled) => console.log('交互變更:', interactionEnabled);

</script>

<template>
  <div style="width: 100vw; height: 100vh;">
    <VueFlow :default-viewport="{ zoom: 0.6, x: 0, y: 0 }" v-model:nodes="nodes" v-model:edges="edges" :node-types="nodeTypes" :connect-on-click="true"
      >
      <Background pattern-color="#aaa" :gap="16" />
      <MiniMap />
      <Controls @zoom-in="onZoomIn" @zoom-out="onZoomOut" @fit-view="onFitView" @interaction-change="onInteractionChange" />
      <SaveRestoreControls :flow-id="flowId" />
    </VueFlow>
    <Sidebar @addNode="onNodeAdded" />
  </div>
</template>

<style>
@import '@vue-flow/core/dist/style.css';
@import '@vue-flow/core/dist/theme-default.css';
@import './assets/commonStyles.css';
</style>