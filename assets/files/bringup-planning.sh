#!/bin/bash

roslaunch ur5_e_moveit_config ur5_e_moveit_planning_execution.launch limited:=false &
sleep 1
roslaunch ur5_e_moveit_config moveit_rviz.launch config:=true &
sleep 1

wait $(jobs -p)