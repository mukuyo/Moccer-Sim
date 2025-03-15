#include "robot.h"
#include <cmath>

Robot::Robot(QObject *parent)
    : QObject(parent),
      id(0),
      kickspeedx(0.0f),
      kickspeedz(0.0f),
      veltangent(0.0f),
      velnormal(0.0f),
      velangular(0.0f),
      spinner(false),
      wheelsspeed(false),
      wheel1(0.0f),
      wheel2(0.0f),
      wheel3(0.0f),
      wheel4(0.0f) {}

Robot::~Robot() = default;

void Robot::visionUpdate(mocSim_Robot_Command robotCommand) {
    id = robotCommand.id();
    kickspeedx = robotCommand.kickspeedx();
    kickspeedz = robotCommand.kickspeedz();
    veltangent = robotCommand.veltangent();
    velnormal = robotCommand.velnormal();
    velangular = robotCommand.velangular();
    spinner = robotCommand.spinner();
    wheelsspeed = robotCommand.wheelsspeed();
    wheel1 = robotCommand.wheel1();
    wheel2 = robotCommand.wheel2();
    wheel3 = robotCommand.wheel3();
    wheel4 = robotCommand.wheel4();
}

void Robot::controlUpdate(RobotCommand robotCommand) {
    id = robotCommand.id();

    if (robotCommand.has_kick_speed() && robotCommand.kick_speed() > 0) {
        double kickSpeed = robotCommand.kick_speed();
        double limit = robotCommand.kick_angle() > 0 ? 10 : 10;
        if (kickSpeed > limit) {
            kickSpeed = limit;
        }
        double kickAngle = robotCommand.kick_angle() * M_PI / 180.0;
        double length = cos(kickAngle) * kickSpeed;
        double z = sin(kickAngle) * kickSpeed;
        
        kickspeedx = length;
        kickspeedz = z;
    }

    if (robotCommand.has_dribbler_speed()) {
        // robot->kicker->setRoller(robotCommand.dribbler_speed() > 0 ? 1 : 0);
    }

    if (robotCommand.has_move_command()) {
        processMoveCommand(robotCommand.move_command());
    }
}

void Robot::processMoveCommand(const RobotMoveCommand &moveCommand) {
    if (moveCommand.has_wheel_velocity()) {
        // auto &wheelVel = moveCommand.wheel_velocity();
        // robot->setSpeed(0, wheelVel.front_right());
        // robot->setSpeed(1, wheelVel.back_right());
        // robot->setSpeed(2, wheelVel.back_left());
        // robot->setSpeed(3, wheelVel.front_left());
    } else if (moveCommand.has_local_velocity()) {
        auto &vel = moveCommand.local_velocity();
        velnormal = vel.left();
        veltangent = vel.forward();
        velangular = vel.angular();
    } else if(moveCommand.has_global_velocity()) {
        // auto &vel = moveCommand.global_velocity();
        // dReal orientation = -robot->getDir() * M_PI / 180.0;
        // dReal vx = (vel.x() * cos(orientation)) - (vel.y() * sin(orientation));
        // dReal vy = (vel.y() * cos(orientation)) + (vel.x() * sin(orientation));
        // robot->setSpeed(vx, vy, vel.angular());
    }  else {
        // SimulatorError *pError = robotControlResponse.add_errors();
        // pError->set_code("GRSIM_UNSUPPORTED_MOVE_COMMAND");
        // pError->set_message("Unsupported move command");
    }
}

uint32_t Robot::getId() const { return id; }
float Robot::getKickspeedx() const { return kickspeedx; }
float Robot::getKickspeedz() const { return kickspeedz; }
float Robot::getVeltangent() const { return veltangent; }
float Robot::getVelnormal() const { return velnormal; }
float Robot::getVelangular() const { return velangular; }
float Robot::getSpinner() const { return spinner; }
bool Robot::getWheelsspeed() const { return wheelsspeed; }
float Robot::getWheel1() const { return wheel1; }
float Robot::getWheel2() const { return wheel2; }
float Robot::getWheel3() const { return wheel3; }
float Robot::getWheel4() const { return wheel4; }
