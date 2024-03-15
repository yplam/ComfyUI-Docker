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
rm -rf $instance_name
git clone https://github.com/comfyanonymous/ComfyUI.git $instance_name
cd $instance_name/custom_nodes

for i in "${instance_nodes[@]}"
do
    git clone $i
done

node_dirs=$(ls -d */)

if [ "$instance_name" != "base" ]; then
    for i in "${base_nodes[@]}"
    do
        git clone $i
    done
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
    mkdir "./build/requirements_$instance_name/$i"
    cp "./instances/$instance_name/custom_nodes/${i}requirements.txt" "./build/requirements_$instance_name/$i"
done