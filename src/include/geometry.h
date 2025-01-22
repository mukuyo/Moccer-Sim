#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <Qt3DCore/QEntity>

class Geometry : public Qt3DCore::QEntity {
    Q_OBJECT
public:
    Geometry(Qt3DCore::QEntity *rootEntity = nullptr);
    ~Geometry();

private:
    void create_fileds(Qt3DCore::QEntity *rootEntity);
    void create_lines(Qt3DCore::QEntity *rootEntity);
};

#endif // GEOMETRY_H
