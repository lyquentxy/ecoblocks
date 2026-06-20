# Web 管理面板

## 职责

Android 内嵌 HTTP Server，提供：

- Blockly 编辑器界面
- 实时数据仪表盘
- 历史数据图表
- 规则管理

## 访问方式

```text
手机浏览器: http://localhost:8080
局域网设备: http://<android-ip>:8080
```

## 技术方案

- HTTP Server: NanoHTTPD (Kotlin)
- 前端: 纯静态 HTML/CSS/JS (无需打包工具)
- 图表: Chart.js 或 ECharts (轻量)
- Blockly: 与 blockly 模块共用

## 页面规划

| 页面 | 功能 |
|---|---|
| `/` | 仪表盘首页 |
| `/blockly` | 积木块编辑器 |
| `/rules` | 规则列表管理 |
| `/history` | 历史数据图表 |
| `/settings` | 系统设置 |
