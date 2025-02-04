cmake_minimum_required(VERSION 3.16)
project(Moccer)

# Qt設定
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets 3DCore 3DExtras 3DRender Quick Quick3D)

set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)

file(GLOB HEADERS ${SRC_DIR}/include/*.h)

# Ensure moc is run on header files
qt6_wrap_cpp(MOC_SRCS
    ${HEADERS}
)

add_executable(Moccer main.cpp src/robot.cpp ${MOC_SRCS})

target_link_libraries(Moccer
    Qt6::Core 
    Qt6::Gui
    Qt6::Widgets 
    Qt6::3DCore 
    Qt6::3DExtras 
    Qt6::3DRender
    Qt6::Quick 
    Qt6::Quick3D
    Qt6::Qml
)
