cmake_minimum_required(VERSION 3.16)
project(GUI)

# Qt設定
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets 3DCore 3DExtras 3DRender)

add_executable(GUI main.cpp src/geometry.cpp src/lighting.cpp src/robot.cpp)

target_link_libraries(GUI
    Qt6::Core 
    Qt6::Gui 
    Qt6::Widgets 
    Qt6::3DCore 
    Qt6::3DExtras 
    Qt6::3DRender
)
