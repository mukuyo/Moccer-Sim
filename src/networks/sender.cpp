#include "sender.h"
#include <iostream>
#include <thread>
#include <chrono>

Sender::Sender() :
    ioContext_(),
    socket_(ioContext_),
    endpoint_(boost::asio::ip::make_address("127.0.0.1"), 10694) {  // Use make_address here
    socket_.open(boost::asio::ip::udp::v4()); // Open the UDP socket
}

Sender::~Sender() {
    socket_.close(); // Close the socket when done
}

void Sender::send(QVector3D ball_position, QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions) {
    SSL_WrapperPacket packet;

    SSL_DetectionFrame detection;
    detection.set_frame_number(0);
    detection.set_t_capture(0);
    detection.set_t_sent(0);
    detection.set_camera_id(0);

    SSL_DetectionBall* ball = detection.add_balls();
    ball->set_confidence(1.0);
    ball->set_x(ball_position.x()*10);
    ball->set_y(ball_position.y()*10);
    ball->set_z(ball_position.z()*10);
    ball->set_pixel_x(0);
    ball->set_pixel_y(0);
    
    for (int i = 0; i < blue_positions.size(); ++i) {
        SSL_DetectionRobot* robot = detection.add_robots_blue();
        robot->set_robot_id(i);
        robot->set_confidence(1.0);
        robot->set_x(blue_positions[i].x()*10.0);
        robot->set_y(blue_positions[i].y()*10.0);
        robot->set_orientation(blue_positions[i].z()*3.14/180.0);
        robot->set_pixel_x(0);
        robot->set_pixel_y(0);
    }

    for (int i = 0; i < yellow_positions.size(); ++i) {
        SSL_DetectionRobot* robot = detection.add_robots_yellow();
        robot->set_robot_id(i);
        robot->set_confidence(1.0);
        robot->set_x(yellow_positions[i].x()*10.0);
        robot->set_y(yellow_positions[i].y()*10.0);
        robot->set_orientation(yellow_positions[i].z()*3.14/180);
        robot->set_pixel_x(0);
        robot->set_pixel_y(0);
    }

    

    SSL_GeometryData geometry;
    SSL_GeometryFieldSize* field = geometry.mutable_field();
    field->set_field_length(12000);
    field->set_field_width(9000);
    field->set_goal_width(1800);
    field->set_goal_depth(180);
    field->set_boundary_width(300);
    SSL_FieldLineSegment* line = field->add_field_lines();
    line->set_name("TopTouchLine");
    Vector2f* p1 = line->mutable_p1();
    p1->set_x(-6000);
    p1->set_y(4500);
    Vector2f* p2 = line->mutable_p2();
    p2->set_x(6000);
    p2->set_y(4500);
    line->set_thickness(50);

    SSL_FieldCircularArc* arc = field->add_field_arcs();
    arc->set_name("CenterCircle");
    Vector2f* center = arc->mutable_center();
    center->set_x(0);
    center->set_y(0);
    arc->set_radius(500);
    arc->set_a1(0);
    arc->set_a2(6.28319);
    arc->set_thickness(50);

    SSL_GeometryCameraCalibration* camera = geometry.add_calib();
    camera->set_camera_id(0);
    camera->set_focal_length(3.0);
    camera->set_principal_point_x(0.0);
    camera->set_principal_point_y(0.0);
    camera->set_distortion(0.0);
    camera->set_q0(0.0);
    camera->set_q1(0.0);
    camera->set_q2(0.0);
    camera->set_q3(0.0);
    camera->set_tx(0.0);
    camera->set_ty(0.0);
    camera->set_tz(0.0);

    packet.mutable_detection()->CopyFrom(detection);
    packet.mutable_geometry()->CopyFrom(geometry);

    std::string serializedData;
    if (!packet.SerializeToString(&serializedData)) {
        std::cerr << "Failed to serialize command." << std::endl;
        return;
    }

    // cout << "Sending packet with size: " << serializedData.size() << endl;

    // Send the serialized data using the UDP socket
    socket_.send_to(boost::asio::buffer(serializedData), endpoint_);
}

