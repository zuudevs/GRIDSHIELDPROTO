/**
 * @file error.hpp
 * @author zuudevs (zuudevs@gmail.com)
 * @brief 
 * @version 0.2
 * @date 2026-02-03
 * 
 * @copyright Copyright (c) 2026
 * 
 */

#pragma once

#pragma once

#if defined(__AVR__)
  #include "../util/move.hpp"
#else
  #include <utility>
#endif

#include <stdint.h>

namespace gridshield::core {

enum class ErrorCode : uint16_t {
    Success = 0,
    SystemNotInitialized = 100,
    SystemAlreadyInitialized = 101,
    SystemShutdown = 102,
    InvalidState = 103,
    ResourceExhausted = 104,
    HardwareFailure = 200,
    SensorReadFailure = 201,
    SensorNotCalibrated = 202,
    TamperDetected = 203,
    PowerLossDetected = 204,
    CryptoFailure = 300,
    AuthenticationFailed = 301,
    IntegrityViolation = 302,
    KeyGenerationFailed = 303,
    SignatureInvalid = 304,
    EncryptionFailed = 305,
    DecryptionFailed = 306,
    NetworkTimeout = 400,
    NetworkDisconnected = 401,
    TransmissionFailed = 402,
    InvalidPacket = 403,
    BufferOverflow = 404,
    AnomalyDetected = 500,
    ProfileMismatch = 501,
    ThresholdExceeded = 502,
    DataInvalid = 503,
    InvalidParameter = 600,
    ConfigurationError = 601,
    CalibrationRequired = 602,
    Unknown = 900,
    NotImplemented = 901,
    NotSupported = 902
};

class ErrorContext {
public:
    constexpr ErrorContext(ErrorCode code, uint32_t line = 0, const char* file = nullptr) noexcept
        : code_(code), line_(line), file_(file), timestamp_(0) {}
    
    constexpr ErrorCode code() const noexcept { return code_; }
    constexpr uint32_t line() const noexcept { return line_; }
    constexpr const char* file() const noexcept { return file_; }
    constexpr uint32_t timestamp() const noexcept { return timestamp_; }
    
    void set_timestamp(uint32_t ts) noexcept { timestamp_ = ts; }
    
    constexpr bool is_critical() const noexcept {
        return static_cast<uint16_t>(code_) >= 200 && static_cast<uint16_t>(code_) < 400;
    }
    
private:
    ErrorCode code_;
    uint32_t line_;
    const char* file_;
    uint32_t timestamp_;
};

// SIMPLIFIED Result - direct member storage
template<typename T>
class Result {
public:
    explicit Result(const T& value) noexcept 
        : has_value_(true), error_(ErrorCode::Success), value_(value) {}
    
    explicit Result(ErrorContext error) noexcept 
        : has_value_(false), error_(error), value_() {}
    
    Result(const Result&) = delete;
    Result& operator=(const Result&) = delete;
    
    Result(Result&& other) noexcept 
        : has_value_(other.has_value_), error_(other.error_), value_(ZMOVE(other.value_)) {}
    
    bool is_ok() const noexcept { return has_value_; }
    bool is_error() const noexcept { return !has_value_; }
    
    T& value() noexcept { return value_; }
    const T& value() const noexcept { return value_; }
    
    ErrorContext error() const noexcept { return error_; }
    
    T value_or(const T& default_value) const noexcept {
        return has_value_ ? value_ : default_value;
    }
    
private:
    bool has_value_;
    ErrorContext error_;
    T value_;
};

template<>
class Result<void> {
public:
    constexpr Result() noexcept : error_(ErrorCode::Success) {}
    constexpr Result(ErrorContext error) noexcept : error_(error) {}
    
    constexpr bool is_ok() const noexcept { return error_.code() == ErrorCode::Success; }
    constexpr bool is_error() const noexcept { return !is_ok(); }
    constexpr ErrorContext error() const noexcept { return error_; }
    
private:
    ErrorContext error_;
};

#define MAKE_ERROR(code) ::gridshield::core::ErrorContext((code), __LINE__, __FILE__)

} // namespace gridshield::core