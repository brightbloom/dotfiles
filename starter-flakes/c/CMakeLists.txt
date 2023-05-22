cmake_minimum_required(VERSION 3.5)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")

# Set the project name
project (hello_cmake)

# Add an executable
add_executable(hello_cmake main.c)
