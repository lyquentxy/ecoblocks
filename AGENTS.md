# EcoBlocks — Codex 工作指南

## 项目定位

EcoBlocks = 运行在低功耗 Android 设备上的、面向生态系统的可编程自动化平台。

**不是**一个智能鱼缸项目——鱼缸是第一个应用场景。

## 核心架构原则

1. **Android 即 Hub** — Android 设备是唯一主控，不做独立 Hub 硬件
2. **节点是“哑”的** — 硬件节点只负责采集或执行，不做判断
3. **Blockly 是表现层** — 所有 UI 和逻辑在 Android 侧
4. **单线连接** — Android 只接一个 Bus Adapter，节点全部挂总线

## 环境原则

> **所有工具缓存指向项目内的 `.cache/` 目录，不碰 C 盘。**
>
> Gradle、pub、npm 全部走项目 `.cache/`。
> 每次构建前先 `source setenv.sh`。

## 数据原则

> **数据格式不提前设计。用最简 mock 数据驱动，等硬件协议确定后再补字段。**
>
> 过早定义详细字段 = 浪费时间。硬件协议一变全得改。
>
> 正确做法：
> ```json
> {"temp": "mock"}
> {"fan": "mock"}
> ```

## 目录原则

- `app/`：Flutter Android 宿主应用
- `ui/`：可视化交互层，包括 Blockly、dashboard、共享组件
- `agent/`：Hub 智能体、设备模型、协议、嵌入式路线、安全与内存策略
- `examples/`：生态场景示例，不在这里沉淀核心能力
- `docs/`：架构和仓库边界说明
- `tools/`：开发辅助脚本，不放业务代码

## 沟通偏好

- 用户会自己判断技术方向，提供信息而非代做决策
- 仓库按模块组织，每个目录保持独立 README
- 功能点逐个确认，程序是次要的，方向对了再动手

## 技术选型

- 总线: CAN 2.0B 为主，RS-485 Modbus 备选
- Bus Adapter: 优先 CANable 开源方案
- Blockly: Google Blockly 开源库，WebView 容器
- Android 最低 API 21 (5.0)，不再兼容 Android 4.4
- 节点 MCU: STM32G0 / CH32V003 / ATtiny
