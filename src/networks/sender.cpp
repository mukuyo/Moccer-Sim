#include "sender.h"
#include <iostream>
#include <thread>
#include <chrono>

Sender::Sender() :
    ioContext_(),
    socket_(ioContext_),
    endpoint_(boost::asio::ip::make_address("127.0.0.1"), 10694) {  // Use make_address here
    running_ = true;
    socket_.open(boost::asio::ip::udp::v4()); // Open the UDP socket
    timerThread_ = std::thread(&Sender::runTimer, this);
}

Sender::~Sender() {
    running_ = false;
    if (timerThread_.joinable()) {
        timerThread_.join();
    }
    socket_.close(); // Close the socket when done
}

void Sender::send(bool is_yellow) {
    SSL_DetectionFrame packet;
    packet.set_frame_number(0);
    packet.set_t_capture(0);
    packet.set_t_sent(0);
    packet.set_camera_id(0);

    SSL_DetectionBall* ball = packet.add_balls();
    ball->set_confidence(1.0);
    ball->set_x(0.0);
    ball->set_y(0.0);
    ball->set_z(0.0);
    ball->set_pixel_x(0.0);
    ball->set_pixel_y(0.0);

    for (int i = 0; i < 16; i++) {
        SSL_DetectionRobot* robot = packet.add_robots_yellow();
        robot->set_confidence(1.0);
        robot->set_robot_id(i);
        robot->set_x(0.0);
        robot->set_y(0.0);
        robot->set_orientation(0.0);
        robot->set_pixel_x(0.0);
        robot->set_pixel_y(0.0);
    }

    for (int i = 0; i < 16; i++) {
        SSL_DetectionRobot* robot = packet.add_robots_blue();
        robot->set_confidence(1.0);
        robot->set_robot_id(i);
        robot->set_x(0.0);
        robot->set_y(0.0);
        robot->set_orientation(0.0);
        robot->set_pixel_x(0.0);
        robot->set_pixel_y(0.0);
    }
    
    // mocSim_Packet packet;
    
    // mocSim_Commands commands;
    // commands.set_timestamp(1234567890);
    // commands.set_isteamyellow(is_yellow);
    // angle += 0.01;
    // if (angle > 3.14159) {
    //     angle = -3.14159;
    // }
    // for (int i = 0; i < 16; i++) {
    //     auto* command = commands.add_robot_commands();
    //     command->set_id(i);
    //     command->set_kickspeedx(1.0);
    //     command->set_kickspeedz(1.0);
    //     command->set_veltangent(cos(angle));
    //     command->set_velnormal(sin(angle));
    //     command->set_velangular(0.0);
    //     command->set_spinner(true);
    //     command->set_wheelsspeed(0.0);
    //     // command->set_wheel1(0.0);
    //     // command->set_wheel2(0.0);
    //     // command->set_wheel3(0.0);
    //     // command->set_wheel4(0.0);
    // }
    
    // packet.mutable_commands()->CopyFrom(commands);

    std::string serializedData;
    if (!packet.SerializeToString(&serializedData)) {
        std::cerr << "Failed to serialize command." << std::endl;
        return;
    }

    cout << "Sending packet with size: " << serializedData.size() << endl;

    // Send the serialized data using the UDP socket
    socket_.send_to(boost::asio::buffer(serializedData), endpoint_);
}

void Sender::runTimer() {
    const auto frameDuration = std::chrono::milliseconds(1000 / 60); // 60 FPS

    while (running_) {
        auto startTime = std::chrono::high_resolution_clock::now();

        send(true);
        send(false);

        auto endTime = std::chrono::high_resolution_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(endTime - startTime);

        if (elapsed < frameDuration) {
            std::this_thread::sleep_for(frameDuration - elapsed);
        }
    }
}
