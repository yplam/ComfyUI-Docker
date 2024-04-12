#!/bin/bash

instance_name=$1
if [ -z "$instance_name" ]; then
    echo "Please provide an instance name"
    exit 1
fi

if [ ! -f $instance_name ]; then
    echo "Instance config file not found"
    exit 1
fi

readarray base_nodes < base
readarray instance_nodes < $instance_name

cd ./instances

if [ -d $instance_name ]; then
    echo "Instance already exists"
    exit 1
fi

git clone https://github.com/comfyanonymous/ComfyUI.git $instance_name

mkdir -p $instance_name/.cache/huggingface
mkdir -p $instance_name/pysssss-workflows

cd $instance_name/custom_nodes

for i in "${instance_nodes[@]}"
do
    git clone --depth=1 $i
done

node_dirs=$(ls -d */)

if [ "$instance_name" != "base" ]; then
    for i in "${base_nodes[@]}"
    do
        git clone --depth=1 $i
    done
fi


if [ "$instance_name" == "3dpack" ]; then
    mkdir -p ./ComfyUI-3D-Pack/checkpoints
fi


cd ../../../

rm -rf "./build/requirements_$instance_name"
mkdir -p "./build/requirements_$instance_name"
if [ "$instance_name" = "base" ]; then
    mkdir -p "./build/requirements_$instance_name/ComfyUI"
    cp "./instances/$instance_name/requirements.txt" "./build/requirements_$instance_name/ComfyUI"
fi

for i in $node_dirs
do
    echo $i
    source_dir="./instances/$instance_name/custom_nodes/$i"
    target_dir="./build/requirements_$instance_name/$i"
    mkdir $target_dir
    for file in "${source_dir}requirements.txt" "${source_dir}requirements-cuda.txt"; do
        if [ -f "$file" ]; then
            echo $file
            cp $file $target_dir
        fi
    done
done
