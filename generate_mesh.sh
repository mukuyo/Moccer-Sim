#!/bin/bash

export MODEL_DIR=assets/models

# Model Lists
models=("ball" "bot" "stadium" "frame" "plane" "wheel")

for model in "${models[@]}"; do
    # Balsam
    balsam "$MODEL_DIR/$model/$model.obj" -o "$MODEL_DIR/$model/"
    
    # Cooker
    if [[ "$model" != "bot" && "$model" != "stadium" ]]; then
        find "$MODEL_DIR/$model/meshes" -name "*.mesh" -exec cooker {} \;
        find . -maxdepth 1 -name "*.tri" -exec mv {} "$MODEL_DIR/$model/meshes/" \;
        find . -maxdepth 1 -name "*.cvx" -exec mv {} "$MODEL_DIR/$model/meshes/" \;
    fi
done
