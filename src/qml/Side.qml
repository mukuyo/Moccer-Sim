import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: opaque_255_215_119__material
        objectName: "Opaque(255,215,119)"
        baseColor: "#ffffd777"
    }
    PrincipledMaterial {
        id: opaque_160_160_160__material
        objectName: "Opaque(160,160,160)"
        baseColor: "#ffa0a0a0"
    }
    PrincipledMaterial {
        id: ____________________material
        objectName: "アルミニウム_-_陽極酸化_光沢(青)"
        baseColor: "#ffffd643"
    }

    // Nodes:
    Node {
        id: side_obj
        objectName: "side.obj"
        Model {
            id: side
            objectName: "side"
            source: "meshes/side_mesh.mesh"
            materials: [
                opaque_255_215_119__material,
                opaque_160_160_160__material,
                ____________________material
            ]
        }
    }

    // Animations:
}
