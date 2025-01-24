# Moccer-Sim

## Introduction
Welcome to Moccer-Sim,  for the [RoboCup Soccer Small Size League (SSL)](https://ssl.robocup.org/).

## System Requirements
Before you dive into the exciting world of RoboCup Soccer SSL with `Moccer-Sim`, ensure your system meets the following minimal requirements:

- **Qt6**: Only Version 6.7
- **Protocol Buffer Compiler**: `protoc` is essential for compiling protocol buffers.
  
## Getting Started
To get started with `Moccer-Sim`, follow these simple steps:

1. Install Dependencies:
Ensure you have all the necessary packages installed. Open your terminal and run:
   ```bash
      brew update
      brew install qt eigen protobuf@21 yaml-cpp vulkan-volk
   ```

2. Make:
  ```bash
      cd ~/ws/ssl-RACOON-GUI
      mkdir build && cd build
      cmake ..
      make
  ```

3.Launch the GUI: Execute the main application to start the GUI.
  ```bash
  make run
  ```

## Related Tools

Enhance your RoboCup Soccer SSL experience further with these related tools:

- [ssl-game-controller](https://github.com/RoboCup-SSL/ssl-game-controller) - The official game controller for managing match flow and rules.
- [ssl-autorefs](https://github.com/RoboCup-SSL/ssl-autorefs) - Automated referee systems for unbiased and accurate game officiating.

## Contributing

We welcome contributions from the community! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get involved.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
