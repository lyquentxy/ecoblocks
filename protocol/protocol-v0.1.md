# EcoBlocks 总线协议 v0.1

## 物理层

- CAN 2.0B (29-bit ID) @ 125kbps / 500kbps 可选
- RS-485 Modbus RTU 可选备选
- Android 侧通过 USB-CAN 适配器接入

## 帧结构

### CAN 帧定义

```
ID 格式 (29-bit):
┌─────┬──────┬──────┬──────────┐
│ PRI │ TYPE │ ADDR │ FUNCTION │
│ 3bit│ 4bit │ 8bit │  14bit   │
└─────┴──────┴──────┴──────────┘
```

| 字段 | 位宽 | 说明 |
|---|---|---|
| PRI | 3 | 优先级 (0=最高) |
| TYPE | 4 | 消息类型 |
| ADDR | 8 | 节点地址 (0x00=广播, 0xFF=主控) |
| FUNCTION | 14 | 功能码 |

### 消息类型 (TYPE)

| 值 | 类型 | 说明 |
|---|---|---|
| 0x0 | DATA | 传感器数据上报 |
| 0x1 | CMD | 控制指令 |
| 0x2 | ACK | 应答 |
| 0x3 | NACK | 错误应答 |
| 0x4 | DISCOVERY | 节点发现 |
| 0x5 | HEARTBEAT | 心跳 |

### 节点地址分配

| 地址 | 节点 |
|---|---|
| 0x00 | 广播 |
| 0x01-0x0F | 温度类节点 |
| 0x10-0x1F | 灯光类节点 |
| 0x20-0x2F | 流量/水泵类节点 |
| 0x30-0x3F | 摄像头类节点 |
| 0xF0-0xFE | 保留 |
| 0xFF | Android 主控 |

## 数据负载格式

### 温度上报 (TYPE=DATA, FUNCTION=0x0001)

```
Byte 0-1:  温度值 (int16, 单位 0.01°C)
Byte 2:    传感器类型
Byte 3-6:  时间戳 (uint32, 相对秒)
```

### 光照控制 (TYPE=CMD, FUNCTION=0x0100)

```
Byte 0:    通道 (0=全部)
Byte 1:    PWM 值 (0-255)
Byte 2-3:  渐变时间 (uint16, 毫秒)
```

## Android 侧接口

```kotlin
// 协议抽象层 — 不关心底层是 CAN 还是 RS-485
interface BusProtocol {
    fun send(target: Byte, command: Command): Result
    fun onData(callback: (NodeData) -> Unit)
    fun discover(): List<NodeInfo>
}
```
