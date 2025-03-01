#ifndef SENDER_H
#define SENDER_H

#include <iostream>
#include <thread>
#include <chrono>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include <boost/optional.hpp>
#include <boost/asio.hpp>
#include <boost/array.hpp>

#include "ssl_vision_detection.pb.h"

using namespace std;

class Sender {
public:
    Sender();
    ~Sender();
    void send(bool is_yellow);

private:
    void runTimer();
    bool running_;
    std::thread timerThread_;
    
    // Networking related members
    boost::asio::io_context ioContext_;
    boost::asio::ip::udp::socket socket_;
    boost::asio::ip::udp::endpoint endpoint_;

    float angle;
};

#endif // SENDER_H
