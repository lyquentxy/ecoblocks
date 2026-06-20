# EcoBlocks

> 运行在低功耗 Android 设备上的、面向生态系统的可编程自动化平台。

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 这是什么

EcoBlocks 让你用**可视化积木块编程**来定义生态系统的自动化逻辑——不需要写代码。

```text
如果 温度 > 30℃  →  打开风扇
如果 日落后1小时  →  打开月光灯
如果 流量下降50%  →  推送通知
```

**第一个场景：智能鱼缸。** 但远不止于此。

## 架构

```text
Android 设备（主控/Hub）
        │
    USB-C (单线)
        │
   Bus Adapter (CAN / RS-485)
        │
   ───┴───┬───┬───┬───
   ▼      ▼   ▼   ▼
 Temp  Light Flow Cam
 Node  Node  Node Node
```

### 两层分工

| 层 | 运行什么 | 职责 |
|---|---|---|
| **Android 主控** | Blockly 引擎、自动化规则、SQLite、Web Dashboard、AI | 思考、决策、存储、展示 |
| **硬件节点** | 裸机固件（MCU） | 采集或执行，不做判断 |

节点是"哑"的——只负责感知和动作，所有逻辑在 Android 侧。

## 仓库结构

```text
ecoblocks/
├── android/          # Android 主控应用
│   ├── app/          # 主应用模块
│   ├── blockly/      # Blockly 积木块引擎（魔改）
│   ├── automation/   # 自动化规则引擎
│   └── dashboard/    # Web 管理面板
├── protocol/         # 总线通信协议定义
├── hardware/         # 硬件节点
│   ├── temp-node/    # 温度节点
│   ├── light-node/   # 灯光节点
│   ├── flow-node/    # 流量节点
│   └── can-adapter/  # CAN/USB 适配器
├── docs/             # 文档
├── examples/         # 示例配置
└── .github/          # CI/CD
```

## 可扩展场景

鱼缸 → 雨林缸 → 苔藓缸 → 水培箱 → 孵化箱 → 昆虫生态箱 → 教育实验平台

## 技术栈

- **主控**: Android 4.4+ (手机 / 电视盒子 / RK3566 / 树莓派Android / 工控主机)
- **总线**: CAN Bus / RS-485 Modbus
- **Blockly**: 开源 Blockly 魔改
- **存储**: SQLite (本地)
- **Web 面板**: 内嵌 HTTP Server (localhost)
- **节点 MCU**: STM32G0 / CH32V003 / ATtiny 等

## 开发状态

🚧 早期规划阶段。欢迎讨论和参与。

## 许可证

MIT License
