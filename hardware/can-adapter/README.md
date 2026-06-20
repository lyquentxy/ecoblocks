# CAN Bus Adapter

## 功能

USB-CAN 桥接器。Android 主控通过 USB 连接此适配器，适配器将 USB 串口数据转换为 CAN 总线帧，反之亦然。

## 硬件方案

优先使用现成开源方案：

- **CANable** (STM32F0): 开源固件，CDC ACM 类设备，Android 免驱
- **备选**: Waveshare USB-CAN, USB2CAN 等

## 固件

> TODO: 基于 CANable 固件定制，增加 EcoBlocks 协议层支持

## 接口

| 方向 | 协议 |
|---|---|
| 上行 (Android) | USB CDC ACM (虚拟串口) |
| 下行 (节点) | CAN 2.0B |
