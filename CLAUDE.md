# EcoBlocks — Claude 工作指南

本文件与 `AGENTS.md` 保持同一套项目原则，供 Claude 或其他协作智能体读取。

## 项目定位

EcoBlocks 是运行在低功耗 Android 设备上的、面向生态系统的可编程自动化平台。鱼缸只是第一个应用场景，不是项目边界。

## 核心原则

- Android 即 Hub，不做独立 Hub 硬件。
- 节点是“哑”的，只采集或执行。
- Blockly 是表现层，核心 UI 和逻辑在 Android 侧。
- Android 只连接一个 Bus Adapter，节点全部挂总线。
- 数据格式不提前设计，先用最简 mock 数据。

## 目录边界

- `app/`：Flutter Android 宿主应用。
- `ui/`：Blockly、dashboard、组件等用户界面。
- `agent/`：Hub runtime、capability、device、protocol、firmware、safety、memory 等核心模块。
- `examples/`：aquarium、terrarium、hydroponics 等场景。
- `docs/`：架构与仓库说明。
- `tools/`：开发工具。

## 环境要求

构建前先执行：

```bash
source setenv.sh
```

所有工具缓存必须落在项目 `.cache/`，不要写 C 盘。
