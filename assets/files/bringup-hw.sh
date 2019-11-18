#!/bin/bash

    roscore &
	sleep 1
	roslaunch ur_modern_driver ur5e_bringup.launch limited:=true robot_ip:=192.168.1.2 &
	sleep 1
	roslaunch rosbag_recorder rosbag_recorder.launch pickle:=true &
	sleep 1

if [ "$1" != "" ]; then
	roslaunch hand_arm hand_bringup.launch profile:=$1 &
else
    roslaunch hand_arm hand_bringup.launch profile:=anthro4 &
    echo "Sending anthro4 configuration to pressure controller "
fi

sleep 1
wait $(jobs -p)