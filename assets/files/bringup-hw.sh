#!/bin/bash
roscore &
sleep 1

# Start the data loggers
roslaunch rosbag_recorder rosbag_recorder.launch pickle:=true &
sleep 1

# Start the robot arm
roslaunch ur_modern_driver ur5e_bringup.launch limited:=true robot_ip:=192.168.1.2 &
sleep 1

# Launch the hand
PROFILE=$2
HARDWARE=$1

roslaunch hand_arm hand_bringup.launch profile:=${PROFILE} hw_profile:=${HARDWARE} plot_profile:=${PROFILE} &
sleep 1

# Wait until everything finishes
wait $(jobs -p)