cmake_minimum_required(VERSION 3.14)

include(cmake/prelude.cmake)

project(
    one
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES CXX
)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Declare library ----

add_library(
    one_lib OBJECT
    source/lib.cpp
)

target_include_directories(
    one_lib ${warning_guard}
    PUBLIC
    "\$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source>"
)

target_compile_features(one_lib PUBLIC cxx_std_20)

find_package(fmt REQUIRED)
target_link_libraries(one_lib PRIVATE fmt::fmt)

# ---- Declare executable ----

add_executable(one_exe source/main.cpp)
add_executable(one::exe ALIAS one_exe)

set_property(TARGET one_exe PROPERTY OUTPUT_NAME one)

target_compile_features(one_exe PRIVATE cxx_std_20)

target_link_libraries(one_exe PRIVATE one_lib)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Developer mode ----

if(NOT one_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of one"
  )
endif()

include(cmake/dev-mode.cmake)
