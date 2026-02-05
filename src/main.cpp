/**
 * @file main.cpp - FIXED VERSION
 * @brief Arduino.h MUST be included FIRST
 */

// CRITICAL: Arduino headers MUST come FIRST before ANY custom headers
#include <Arduino.h>
#include <SoftwareSerial.h>

// NOW include custom headers
#include "core/system.hpp"
#include "platform/arduino/gpio_arduino.hpp"
#include "platform/arduino/platform_arduino.hpp"

using namespace gridshield;

// Platform Drivers
platform::arduino::ArduinoGPIO platformGpio;
platform::arduino::ArduinoTime platformTime;
platform::arduino::ArduinoSerialComm platformComm;
platform::arduino::ArduinoSimpleCrypto platformCrypto;
platform::arduino::ArduinoInterruptStub platformInterrupt;
platform::arduino::ArduinoStorageStub platformStorage;

platform::PlatformServices services;
GridShieldSystem* gridSystem = nullptr;

void setup() {
    Serial.begin(115200);
    while (!Serial) { delay(10); }
    
    Serial.println("\n=== Booting GridShield v1.0 ===");

    services.gpio = &platformGpio;
    services.time = &platformTime;
    services.comm = &platformComm;
    services.crypto = &platformCrypto;
    services.interrupt = &platformInterrupt;
    services.storage = &platformStorage;

    SystemConfig config;
    config.meter_id = 0xEA320001;
    config.heartbeat_interval_ms = 5000;
    config.reading_interval_ms = 10000;
    config.tamper_config.sensor_pin = 0;
    config.tamper_config.debounce_ms = 50;

    gridSystem = new GridShieldSystem();
    if (gridSystem == nullptr) {
        Serial.println("FATAL: Memory allocation failed!");
        while(1) delay(1000);
    }

    Serial.print("Initializing... ");
    auto initResult = gridSystem->initialize(config, services);
    
    if (initResult.is_error()) {
        Serial.print("FAILED! Code: ");
        Serial.println((int)initResult.error().code());
        while(1) delay(1000);
    }
    Serial.println("OK!");

    Serial.print("Starting... ");
    auto startResult = gridSystem->start();
    
    if (startResult.is_error()) {
        Serial.println("FAILED!");
    } else {
        Serial.println("OK! Running.");
    }
}

void loop() {
    if (gridSystem) {
        gridSystem->process_cycle();
    }
    delay(10);
}
