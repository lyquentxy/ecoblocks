# EcoBlocks App

## 主应用模块

Android 应用入口。负责：

- Application 生命周期
- USB 设备检测与连接
- 各模块初始化与协调
- 后台 Service 保活 (自动化规则持续运行)

## 启动流程

```text
App 启动
  → 检测 USB OTG
  → 连接 Bus Adapter
  → 扫描总线节点
  → 启动自动化引擎
  → 启动 Web Dashboard
  → 进入就绪状态
```
