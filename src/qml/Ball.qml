import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import MOC

import "../../assets/models/ball/"

Node {
    id: ballNode

    DynamicRigidBody {
        id: ball
        position: Qt.vector3d(50, 0, 0)
        gravityEnabled: true
        // physicsMaterial: physicsMaterial2
        collisionShapes: ConvexMeshShape {
            id: sphereShape
            source: "../../assets/models/ball/meshes/icosphere_mesh.cooked.cvx"
        }
        Ball {
        }
    }
}
