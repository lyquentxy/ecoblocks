# EcoBlocks Legacy Android 4.4 Route

## 定位

Android 4.4 是 API 19，作为低内存 Hub 控制端单独规划，不和现代 Flutter 主线共用 APK。

## 技术边界

- 原生 Android API19 + 系统 WebView + 简单原生 UI
- 共享 EcoBlocks 的 mock 数据原则和总线方向
- 可显示设备状态、设置、运行日志，并执行已保存的 mock/规则
- 不承诺完整 Blockly 编辑体验

## 与现代主线的关系

现代 Flutter App 负责完整工作区、Blockly 编辑和后续跨页面共享 Hub 状态。Legacy 版本只做低内存运行端，后续通过导入已保存规则或最简表单式规则接入。

## 后续入口

真正开始实现时再新增 Android 工程骨架；当前目录只固定路线和边界，避免把 API19 兼容压力带进现代 Flutter 主线。
