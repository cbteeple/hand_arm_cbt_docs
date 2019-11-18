#!/bin/bash

if [ "$1" != "" ]; then
	roslaunch hand_arm pick-place-build-multi.launch traj:=$1
	wait
	echo "Done Building"
	roslaunch hand_arm pick-place-plan-multi.launch traj:=$1
	wait
	echo "Done Planning"
else
    echo "Please input a trajectory to build/plan"
fi