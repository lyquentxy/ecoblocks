# Temperature Node

Purpose: collect temperature-like readings and report them to the Android Hub.

The node does not decide. It only senses.

Candidate parts:

- DS18B20, NTC, or SHT30 sensor.
- STM32G0, CH32V003, or similar small MCU.
- CAN-first bus direction.

Keep payloads mock-minimal until hardware tests settle the protocol.
