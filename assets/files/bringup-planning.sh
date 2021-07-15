#!/bin/bash

roslaunch ${1}_moveit_config ${1}_moveit_planning_execution.launch limited:=false &
sleep 1

roslaunch ${1}_moveit_config moveit_rviz.launch config:=true &
sleep 1

wait $(jobs -p)