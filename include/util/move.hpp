#pragma once

#if defined(__AVR__)

template <typename T>
struct remove_reference {
    using type = T;
};

template <typename T>
struct remove_reference<T&> {
    using type = T;
};

template <typename T>
struct remove_reference<T&&> {
    using type = T;
};

template <typename T>
typename remove_reference<T>::type&& move(T&& arg) {
  return static_cast<typename remove_reference<T>::type&&>(arg);
}

  #define ZMOVE(x) move(x)
#else
  #include <utility>
  #define ZMOVE(x) std::move(x)
#endif