#!/bin/bash

export MODEL_DIR=assets/models

# Model Lists
models=("ball" "stadium" "plane")

for model in "${models[@]}"; do
    # Balsam
    balsam "$MODEL_DIR/$model/$model.obj" -o "$MODEL_DIR/$model/"
    
    # Cooker
    if [[ "$model" != "stadium" ]]; then
        find "$MODEL_DIR/$model/meshes" -name "*.mesh" -exec cooker {} \;
        find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/$model/meshes/" \;
        find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/$model/meshes/" \;
    fi
done

balsam "$MODEL_DIR/bot/blue/rigid_body/frame.obj" -o "$MODEL_DIR/bot/blue/rigid_body/"
balsam "$MODEL_DIR/bot/blue/viz/body/body.obj" -o "$MODEL_DIR/bot/blue/viz/body/"
balsam "$MODEL_DIR/bot/blue/viz/wheel/wheel.obj" -o "$MODEL_DIR/bot/blue/viz/wheel/"
balsam "$MODEL_DIR/bot/yellow/rigid_body/frame.obj" -o "$MODEL_DIR/bot/yellow/rigid_body/"
balsam "$MODEL_DIR/bot/yellow/viz/body/body.obj" -o "$MODEL_DIR/bot/yellow/viz/body/"
balsam "$MODEL_DIR/bot/yellow/viz/wheel/wheel.obj" -o "$MODEL_DIR/bot/yellow/viz/wheel/"

find "$MODEL_DIR/bot/blue/rigid_body/meshes" -name "*.mesh" -exec cooker {} \;
find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/bot/blue/rigid_body/meshes/" \;
find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/bot/blue/rigid_body/meshes/" \;
find "$MODEL_DIR/bot/blue/viz/body/meshes" -name "*.mesh" -exec cooker {} \;
find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/bot/blue/viz/body/meshes/" \;
find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/bot/blue/viz/body/meshes/" \;
find "$MODEL_DIR/bot/blue/viz/wheel/meshes" -name "*.mesh" -exec cooker {} \;
find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/bot/blue/viz/wheel/meshes/" \;
find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/bot/blue/viz/wheel/meshes/" \;
find "$MODEL_DIR/bot/yellow/rigid_body/meshes" -name "*.mesh" -exec cooker {} \;
find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/bot/yellow/rigid_body/meshes/" \;
find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/bot/yellow/rigid_body/meshes/" \;
find "$MODEL_DIR/bot/yellow/viz/body/meshes" -name "*.mesh" -exec cooker {} \;
find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/bot/yellow/viz/body/meshes/" \;
find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/bot/yellow/viz/body/meshes/" \;
find "$MODEL_DIR/bot/yellow/viz/wheel/meshes" -name "*.mesh" -exec cooker {} \;
find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/bot/yellow/viz/wheel/meshes/" \;
find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/bot/yellow/viz/wheel/meshes/" \;