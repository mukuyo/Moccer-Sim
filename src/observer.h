#ifndef OBSERVER_H
#define OBSERVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <QSettings>
#include <iostream>
#include "networks/receiver.h"
#include "networks/sender.h"
#include "models/robot.h"
#include "mocSim_Packet.pb.h"
#include "ssl_simulation_robot_control.pb.h"

using namespace std;

class Observer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> blue_robots READ getBlueRobots NOTIFY blueRobotsChanged)
    Q_PROPERTY(QList<QObject*> yellow_robots READ getYellowRobots NOTIFY yellowRobotsChanged)
    Q_PROPERTY(int windowWidth READ getWindowWidth WRITE setWindowWidth NOTIFY settingChanged)
    Q_PROPERTY(int windowHeight READ getWindowHeight WRITE setWindowHeight NOTIFY settingChanged)
    Q_PROPERTY(QString visionMulticastAddress READ getVisionMulticastAddress WRITE setVisionMulticastAddress NOTIFY settingChanged)
    Q_PROPERTY(int visionMulticastPort READ getVisionMulticastPort WRITE setVisionMulticastPort NOTIFY settingChanged)
    Q_PROPERTY(int commandListenPort READ getCommandListenPort WRITE setCommandListenPort NOTIFY settingChanged)
    Q_PROPERTY(int blueTeamControlPort READ getBlueTeamControlPort WRITE setBlueTeamControlPort NOTIFY settingChanged)
    Q_PROPERTY(int yellowTeamControlPort READ getYellowTeamControlPort WRITE setYellowTeamControlPort NOTIFY settingChanged)
    Q_PROPERTY(bool forceDebugDrawMode READ getForceDebugDrawMode WRITE setForceDebugDrawMode NOTIFY settingChanged)
    Q_PROPERTY(bool lightBlueRobotMode READ getLightBlueRobotMode WRITE setLightBlueRobotMode NOTIFY settingChanged)
    Q_PROPERTY(bool lightYellowRobotMode READ getLightYellowRobotMode WRITE setLightYellowRobotMode NOTIFY settingChanged)
    Q_PROPERTY(bool lightStadiumMode READ getLightStadiumMode WRITE setLightStadiumMode NOTIFY settingChanged)
    Q_PROPERTY(bool lightFieldMode READ getLightFieldMode WRITE setLightFieldMode NOTIFY settingChanged)
    Q_PROPERTY(int blueRobotCount READ getBlueRobotCount WRITE setBlueRobotCount NOTIFY settingChanged)
    Q_PROPERTY(int yellowRobotCount READ getYellowRobotCount WRITE setYellowRobotCount NOTIFY settingChanged)
    Q_PROPERTY(float ballStaticFriction READ getBallStaticFriction WRITE setBallStaticFriction NOTIFY settingChanged)
    Q_PROPERTY(float ballDynamicFriction READ getBallDynamicFriction WRITE setBallDynamicFriction NOTIFY settingChanged)
    Q_PROPERTY(float ballRestitution READ getBallRestitution WRITE setBallRestitution NOTIFY settingChanged)
    Q_PROPERTY(float gravity READ getGravity WRITE setGravity NOTIFY settingChanged)
    Q_PROPERTY(float desiredFps READ getDesiredFps WRITE setDesiredFps NOTIFY settingChanged)
    Q_PROPERTY(bool ccdMode READ getCcdMode WRITE setCcdMode NOTIFY settingChanged)

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    Q_INVOKABLE void updateObjects(
        QList<QVector3D> blue_positions, 
        QList<QVector3D> yellow_positions, 
        QList<QVector2D> blueBallPixels, 
        QList<QVector2D> yellowBallPixels,
        QList<bool> blueBallCameraExists,
        QList<bool> yellowBallCameraExists,
        QList<bool> bBotBallContacts, 
        QList<bool> yBotBallContacts, 
        QVector3D ball_position
    );

    void start(quint16 port);
    void stop();

    void visionReceive(mocSim_Packet packet);
    void controlReceive(RobotControl packet, bool isYellow);

    QList<QObject*> getBlueRobots() const {
        QList<QObject*> blueList;
        for (int i = 0; i < blueRobotCount; ++i) {
            blueList.append(blue_robots[i]);
        }
        return blueList;
    }
    QList<QObject*> getYellowRobots() const {
        QList<QObject*> yellowList;
        for (int i = 0; i < yellowRobotCount; ++i) {
            yellowList.append(yellow_robots[i]);
        }
        return yellowList;
    }
    int getWindowWidth() const { return windowWidth; }
    int getWindowHeight() const { return windowHeight; }
    QString getVisionMulticastAddress() const { return visionMulticastAddress; }
    int getVisionMulticastPort() const { return visionMulticastPort; }
    int getCommandListenPort() const { return commandListenPort; }
    int getBlueTeamControlPort() const { return blueTeamControlPort; }
    int getYellowTeamControlPort() const { return yellowTeamControlPort; }
    bool getForceDebugDrawMode() const { return forceDebugDrawMode; }
    bool getLightBlueRobotMode() const { return lightBlueRobotMode; }
    bool getLightYellowRobotMode() const { return lightYellowRobotMode; }
    bool getLightStadiumMode() const { return lightStadiumMode; }
    bool getLightFieldMode() const { return lightFieldMode; }
    int getBlueRobotCount() const { return blueRobotCount; }
    int getYellowRobotCount() const { return yellowRobotCount; }
    float getBallStaticFriction() const { return ballStaticFriction; }
    float getBallDynamicFriction() const { return ballDynamicFriction; }
    float getBallRestitution() const { return ballRestitution; }
    float getGravity() const { return gravity; }
    float getDesiredFps() const { return desiredFps; }
    bool getCcdMode() const { return ccdMode; }
    
    void setWindowWidth(int width);
    void setWindowHeight(int height);
    void setVisionMulticastAddress(const QString &address);
    void setVisionMulticastPort(int port);
    void setCommandListenPort(int port);
    void setBlueTeamControlPort(int port);
    void setYellowTeamControlPort(int port);
    void setForceDebugDrawMode(bool mode);
    void setLightBlueRobotMode(bool mode);
    void setLightYellowRobotMode(bool mode);
    void setLightStadiumMode(bool mode);
    void setLightFieldMode(bool mode);
    void setBlueRobotCount(int count);
    void setYellowRobotCount(int count);
    void setBallStaticFriction(float friction);
    void setBallDynamicFriction(float friction);
    void setBallRestitution(float restitution);
    void setGravity(float gravity);
    void setDesiredFps(float fps);
    void setCcdMode(bool mode);
    
signals:
    void blueRobotsChanged();
    void yellowRobotsChanged();
    void settingChanged();
    void sendBotBallContacts(
        const QList<bool> &bBotBallContacts, 
        const QList<bool> &yBotBallContacts,
        const QList<bool> &bBallCameraExists,
        const QList<bool> &yBallCameraExists,
        const QList<QVector2D> &bBallCameraPositions,
        const QList<QVector2D> &yBallCameraPositions
    );

private:
    QSettings config;

    VisionReceiver *visionReceiver;
    ControlBlueReceiver *controlBlueReceiver;
    ControlYellowReceiver *controlYellowReceiver;

    Sender *sender;

    Robot *blue_robots[16];
    Robot *yellow_robots[16];

    int windowWidth;
    int windowHeight;

    QString visionMulticastAddress;
    int visionMulticastPort;
    int commandListenPort;
    int blueTeamControlPort;
    int yellowTeamControlPort;

    bool forceDebugDrawMode;
    bool lightBlueRobotMode;
    bool lightYellowRobotMode;
    bool lightStadiumMode;
    bool lightFieldMode;

    int blueRobotCount;
    int yellowRobotCount;

    float ballStaticFriction;
    float ballDynamicFriction;
    float ballRestitution;
    float gravity;
    float desiredFps;
    bool ccdMode;


    RobotControlResponse robotControlResponse;
};

#endif // OBSERVER_H
