#include "sender.h"
#include <iostream>
#include <thread>
#include <chrono>

Sender::Sender(quint16 port, QObject *parent) :
    ioContext_(),
    socket_(ioContext_),
    endpoint_(boost::asio::ip::make_address("224.5.23.2"), port) {
    socket_.open(boost::asio::ip::udp::v4());

    captureCount = 0;
    geometryCount = 0;
}

Sender::~Sender() {
    socket_.close();
}

void Sender::send(int camera_id, QVector3D ball_position, QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions) {
    SSL_WrapperPacket packet;

    if (captureCount == 0) 
        start_time = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();

    if (camera_id == 0)
        t_capture = (std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count() - start_time)/10000.0;
    
    SSL_DetectionFrame detection;
    detection.set_frame_number(captureCount);
    detection.set_t_capture(t_capture);
    detection.set_t_sent(t_capture);
    detection.set_camera_id(camera_id);

    setDetectionInfo(detection, camera_id, ball_position, blue_positions, yellow_positions);

    packet.mutable_detection()->CopyFrom(detection);

    if (geometryCount % 20 == 0) {
        packet.mutable_geometry()->CopyFrom(setGeometryInfo());
    }

    packet.mutable_detection()->CopyFrom(detection);    
    

    std::string serializedData;
    if (!packet.SerializeToString(&serializedData)) {
        std::cerr << "Failed to serialize command." << std::endl;
        return;
    }
    socket_.send_to(boost::asio::buffer(serializedData), endpoint_);

    geometryCount++;
    if (camera_id == 0)
        captureCount++;
}

void Sender::setDetectionInfo(SSL_DetectionFrame detection, int camera_id, QVector3D ball_position, QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions) {
    if ((ball_position.x() > 0 && camera_id == 0) || (ball_position.x() < 0 && camera_id == 1)) {
        SSL_DetectionBall* ball = detection.add_balls();
        ball->set_confidence(1.0);
        ball->set_area(0);
        ball->set_x(ball_position.x()*10);
        ball->set_y(ball_position.y()*10);
        ball->set_z(ball_position.z()*10);
        ball->set_pixel_x(0);
        ball->set_pixel_y(0);
    } 
    
    for (int i = 0; i < blue_positions.size(); ++i) {
        if ((blue_positions[i].x() > 0 && camera_id == 0) || (blue_positions[i].x() < 0 && camera_id == 1)) {
            SSL_DetectionRobot* robot = detection.add_robots_blue();
            robot->set_robot_id(i);
            robot->set_confidence(1.0);
            robot->set_x(blue_positions[i].x()*10.0);
            robot->set_y(blue_positions[i].y()*10.0);
            robot->set_orientation(blue_positions[i].z()*M_PI/180.0);
            robot->set_pixel_x(0);
            robot->set_pixel_y(0);
            robot->set_height(0);
        }
    }

    for (int i = 0; i < yellow_positions.size(); ++i) {
        if ((yellow_positions[i].x() > 0 && camera_id == 0) || (yellow_positions[i].x() < 0 && camera_id == 1)) {
            SSL_DetectionRobot* robot = detection.add_robots_yellow();
            robot->set_robot_id(i);
            robot->set_confidence(1.0);
            robot->set_x(yellow_positions[i].x()*10.0);
            robot->set_y(yellow_positions[i].y()*10.0);
            robot->set_orientation(yellow_positions[i].z()*M_PI/180);
            robot->set_pixel_x(0);
            robot->set_pixel_y(0);
            robot->set_height(0);
        }
    }
}

SSL_GeometryData Sender::setGeometryInfo() {
    SSL_GeometryData geometry;

    SSL_GeometryFieldSize* field = geometry.mutable_field();
    field->set_field_length(12000);
    field->set_field_width(9000);
    field->set_goal_width(1800);
    field->set_goal_depth(180);
    field->set_boundary_width(300);
    SSL_FieldLineSegment* topTouchLine = field->add_field_lines();
    topTouchLine->set_name("TopTouchLine");
    Vector2f point;
    point.set_x(-6000);
    point.set_y(4500);
    topTouchLine->mutable_p1()->CopyFrom(point);
    point.set_x(6000);
    point.set_y(4500);
    topTouchLine->mutable_p2()->CopyFrom(point);
    topTouchLine->set_thickness(10);
    SSL_FieldLineSegment* bottomTouchLine = field->add_field_lines();
    bottomTouchLine->set_name("BottomTouchLine");
    point.set_x(-6000);
    point.set_y(-4500);
    bottomTouchLine->mutable_p1()->CopyFrom(point);
    point.set_x(6000);
    point.set_y(-4500);
    bottomTouchLine->mutable_p2()->CopyFrom(point);
    bottomTouchLine->set_thickness(10);
    SSL_FieldLineSegment* leftGoalLine = field->add_field_lines();
    leftGoalLine->set_name("LeftGoalLine");
    point.set_x(-6000);
    point.set_y(-4500);
    leftGoalLine->mutable_p1()->CopyFrom(point);
    point.set_x(-6000);
    point.set_y(4500);
    leftGoalLine->mutable_p2()->CopyFrom(point);
    leftGoalLine->set_thickness(10);
    SSL_FieldLineSegment* rightGoalLine = field->add_field_lines();
    rightGoalLine->set_name("RightGoalLine");
    point.set_x(6000);
    point.set_y(-4500);
    rightGoalLine->mutable_p1()->CopyFrom(point);
    point.set_x(6000);
    point.set_y(4500);
    rightGoalLine->mutable_p2()->CopyFrom(point);
    rightGoalLine->set_thickness(10);
    SSL_FieldLineSegment* halfWayLine = field->add_field_lines();
    halfWayLine->set_name("HalfWayLine");
    point.set_x(0);
    point.set_y(-4500);
    halfWayLine->mutable_p1()->CopyFrom(point);
    point.set_x(0);
    point.set_y(4500);
    halfWayLine->mutable_p2()->CopyFrom(point);
    halfWayLine->set_thickness(10);
    SSL_FieldCircularArc* centerCircle = field->add_field_arcs();
    centerCircle->set_name("CenterCircle");
    Vector2f* center = centerCircle->mutable_center();
    center->set_x(0);
    center->set_y(0);
    centerCircle->set_radius(500);
    centerCircle->set_a1(0);
    centerCircle->set_a2(6.28319);
    centerCircle->set_thickness(10);
    
    SSL_FieldLineSegment* leftPenaltyStretch = field->add_field_lines();
    leftPenaltyStretch->set_name("LeftPenaltyStretch");
    point.set_x(-4800);
    point.set_y(-1200);
    leftPenaltyStretch->mutable_p1()->CopyFrom(point);
    point.set_x(-4800);
    point.set_y(1200);
    leftPenaltyStretch->mutable_p2()->CopyFrom(point);
    leftPenaltyStretch->set_thickness(10);
    SSL_FieldLineSegment* rightPenaltyStretch = field->add_field_lines();
    rightPenaltyStretch->set_name("RightPenaltyStretch");
    point.set_x(4800);
    point.set_y(-1200);
    rightPenaltyStretch->mutable_p1()->CopyFrom(point);
    point.set_x(4800);
    point.set_y(1200);
    rightPenaltyStretch->mutable_p2()->CopyFrom(point);
    rightPenaltyStretch->set_thickness(10);

    SSL_FieldLineSegment* leftFieldLeftPenaltyStretch = field->add_field_lines();
    leftFieldLeftPenaltyStretch->set_name("LeftFieldLeftPenaltyStretch");
    point.set_x(-6000);
    point.set_y(-1200);
    leftFieldLeftPenaltyStretch->mutable_p1()->CopyFrom(point);
    point.set_x(-4800);
    point.set_y(-1200);
    leftFieldLeftPenaltyStretch->mutable_p2()->CopyFrom(point);
    leftFieldLeftPenaltyStretch->set_thickness(10);
    SSL_FieldLineSegment* leftFieldRightPenaltyStretch = field->add_field_lines();
    leftFieldRightPenaltyStretch->set_name("LeftFieldRightPenaltyStretch");
    point.set_x(-6000);
    point.set_y(1200);
    leftFieldRightPenaltyStretch->mutable_p1()->CopyFrom(point);
    point.set_x(-4800);
    point.set_y(1200);
    leftFieldRightPenaltyStretch->mutable_p2()->CopyFrom(point);
    leftFieldRightPenaltyStretch->set_thickness(10);

    SSL_FieldLineSegment* rightFieldRightPenaltyStretch = field->add_field_lines();
    rightFieldRightPenaltyStretch->set_name("RightFieldRightPenaltyStretch");
    point.set_x(6000);
    point.set_y(-1200);
    rightFieldRightPenaltyStretch->mutable_p1()->CopyFrom(point);
    point.set_x(4800);
    point.set_y(-1200);
    rightFieldRightPenaltyStretch->mutable_p2()->CopyFrom(point);
    rightFieldRightPenaltyStretch->set_thickness(10);
    SSL_FieldLineSegment* rightFieldLeftPenaltyStretch = field->add_field_lines();
    rightFieldLeftPenaltyStretch->set_name("RightFieldLeftPenaltyStretch");
    point.set_x(6000);
    point.set_y(1200);
    rightFieldLeftPenaltyStretch->mutable_p1()->CopyFrom(point);
    point.set_x(4800);
    point.set_y(1200);
    rightFieldLeftPenaltyStretch->mutable_p2()->CopyFrom(point);
    rightFieldLeftPenaltyStretch->set_thickness(10);


    SSL_GeometryCameraCalibration* camera = geometry.add_calib();
    camera->set_camera_id(0);
    camera->set_focal_length(500.0);
    camera->set_principal_point_x(390.0);
    camera->set_principal_point_y(290.0);
    camera->set_distortion(0.0);
    camera->set_q0(0.7);
    camera->set_q1(-0.7);
    camera->set_q2(0.0);
    camera->set_q3(0.0);
    camera->set_tx(0.0);
    camera->set_ty(1250);
    camera->set_tz(3500);
    camera->set_derived_camera_world_tx(0);
    camera->set_derived_camera_world_ty(0);
    camera->set_derived_camera_world_tz(0);
    camera->set_pixel_image_width(780);
    camera->set_pixel_image_height(580);

    return geometry;
}

SenderControl::SenderControl(QObject *parent) :
    QObject(parent),
    ioContext_(),
    socket1_(ioContext_),
    socket2_(ioContext_),
    endpoint1_(boost::asio::ip::make_address("127.0.0.1"), 10301),
    endpoint2_(boost::asio::ip::make_address("127.0.0.1"), 10302)
{
    socket1_.open(boost::asio::ip::udp::v4());
    socket2_.open(boost::asio::ip::udp::v4());
}

SenderControl::~SenderControl() {
    socket1_.close();
    socket2_.close();
}

void SenderControl::send(QList<QVector3D> blue, QList<QVector3D> yellow) {
    _send(blue, "blue");
    _send(yellow, "yellow");
}

void SenderControl::_send(QList<QVector3D> positions, std::string team) {
    if (positions.isEmpty()) return;

    RobotControlResponse packet;

    for (int i = 0; i < positions.length(); i++) {
        RobotFeedback* feedback = packet.add_feedback();
        feedback->set_id(i);
        feedback->set_dribbler_ball_contact(false);
    }

    std::string serializedData;
    if (!packet.SerializeToString(&serializedData)) {
        qCritical() << "Failed to serialize command.";
        return;
    }
    if (team == "yellow") {
        socket2_.send_to(boost::asio::buffer(serializedData), endpoint2_);
    } else {
        socket1_.send_to(boost::asio::buffer(serializedData), endpoint1_);
    }
}