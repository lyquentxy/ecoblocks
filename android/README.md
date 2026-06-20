# EcoBlocks Android

## 最低要求

- Android 4.4 (API 19)
- USB OTG 支持

## 模块

| 模块 | 职责 |
|---|---|
| `app/` | 主应用入口、生命周期管理 |
| `blockly/` | Blockly WebView 容器、自定义积木块 |
| `automation/` | 规则引擎、触发器匹配、动作调度 |
| `dashboard/` | 内嵌 HTTP Server、Web 面板、图表 |

## 目标设备

- 旧 Android 手机 (4.4+)
- 安卓电视盒子
- RK3566 开发板
- 树莓派 + Android
- 工控安卓主机

## 技术栈

- 语言: Kotlin / Java
- HTTP Server: NanoHTTPD (内嵌)
- 数据库: SQLite (Room 或原生)
- 串口通信: USB CDC ACM (android.hardware.usb)
