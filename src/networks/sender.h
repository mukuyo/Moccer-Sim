#ifndef SENDER_H
#define SENDER_H

#include <QObject>
#include <iostream>
#include <thread>
#include <chrono>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include <boost/optional.hpp>
#include <boost/asio.hpp>
#include <boost/array.hpp>
#include <QVector3D>
#include <QList>
#include <QDebug>
#include "ssl_vision_wrapper.pb.h"

using namespace std;

class Sender : public QObject{
    Q_OBJECT
public:
    Sender(quint16 port, QObject *parent = nullptr);
    ~Sender();
    void send(QVector3D ball_position, QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions);

private:
    boost::asio::io_context ioContext_;
    boost::asio::ip::udp::socket socket_;
    boost::asio::ip::udp::endpoint endpoint_;
};

#endif // SENDER_H
