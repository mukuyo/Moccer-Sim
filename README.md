# Moccer-Sim

## Introduction
Welcome to Moccer-Sim, a simulation tool designed for the [RoboCup Soccer Small Size League (SSL)](https://ssl.robocup.org/).

![Moccer Simulation Image](docs/images/readme.png)

## System Requirements
Before diving into the exciting world of RoboCup Soccer SSL with `Moccer-Sim`, ensure your system meets the following requirements:

- **Qt6**: Version 6.8 is supported.
- **Protocol Buffer Compiler**: `protoc` is essential for compiling protocol buffers.

## Getting Started
To get started with `Moccer-Sim`, follow these steps:

### 1. Install Dependencies
Make sure all necessary packages are installed. Open your terminal and run:
### Mac OS
```bash
brew update
brew install qt eigen protobuf@21 yaml-cpp vulkan-volk assimp bullet
```
### Ubuntu
```bash
sudo apt update
sudo apt install qt6-base-dev qt6-declarative-dev qt6-tools-dev qml6-module-* qt6-3d-dev qt6-quick3d-dev qt6-quick3d-dev-tools qt6-shadertools-dev libeigen3-dev protobuf-compiler libyaml-cpp-dev cmake build-essential libassimp-dev assimp-utils libbullet-dev
```

### 2. Preparing 3D Models
To properly visualize the simulation, download the required 3D models and place them in the following directory:
```
~/ws/Moccer-Sim/assets/
```
Currently, we are not distributing 3D models.

### 3. Generating Mesh Files
```bash
chmod +x generating_mesh.sh
./generating_mesh.sh
```

### 4. Building the Project
Set up and build the project using the following steps:

```bash
cd ~/ws/Moccer-Sim/
mkdir build && cd build
cmake ..
make
```

### 5. Launch the GUI
Run the main application to start the GUI:
```bash
make run
```
This command executes the compiled binary and launches the graphical user interface. You can now start interacting with `Moccer-Sim`.

### 6. Additional Notes
If you encounter errors during the build process, ensure all dependencies are installed and up-to-date. For troubleshooting, refer to the [official documentation](https://github.com/RoboCup-SSL/).

## Related Tools
Enhance your RoboCup Soccer SSL experience with these related tools:

- [ssl-game-controller](https://github.com/RoboCup-SSL/ssl-game-controller): The official game controller for managing match flow and rules.
- [ssl-autorefs](https://github.com/RoboCup-SSL/ssl-autorefs): Automated referee systems for unbiased and accurate game officiating.

## Contributing
We welcome contributions from the community! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get involved.

## License
This project is licensed under the MIT License. See the [LICENSE.md](LICENSE) file for details.
