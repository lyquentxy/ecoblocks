# 自动化规则引擎

## 职责

把 Blockly 生成的规则 JSON 变成真实的自动化行为。

## 工作流程

```text
Blockly 积木块
     │
     ▼
规则 JSON
     │
     ▼
规则引擎 (解析 + 注册触发器)
     │
     ▼
传感器数据到达
     │
     ▼
触发器匹配？
 ┌───┴───┐
 ▼       ▼
 是      否 → 忽略
 ▼
执行动作
     │
     ▼
发送指令到节点 / 推送通知 / 记录日志
```

## 规则 JSON 格式 (v0.1)

```json
{
  "id": "rule-001",
  "name": "高温开风扇",
  "trigger": {
    "type": "threshold",
    "sensor": "temp",
    "operator": ">",
    "value": 30,
    "unit": "celsius"
  },
  "condition": {
    "type": "time_range",
    "start": "06:00",
    "end": "22:00"
  },
  "action": {
    "type": "command",
    "target": "fan",
    "command": "on"
  }
}
```

## 触发器类型

| 类型 | 说明 |
|---|---|
| `threshold` | 阈值触发 (>, <, =) |
| `time_cron` | 定时触发 |
| `sun` | 日出日落触发 |
| `change` | 变化率触发 (如流量骤降) |
| `duration` | 持续时长触发 (如温度>28℃超过1小时) |

## 动作类型

| 类型 | 说明 |
|---|---|
| `command` | 向节点发送指令 |
| `notify` | 推送通知 |
| `log` | 记录事件 |
