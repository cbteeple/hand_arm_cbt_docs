---
layout: default
title: System Startup
parent: Tutorials
permalink: /tutorials/system_startup
nav_order: 1
---

# {{ page.title }}

1. TOC
{:toc}

---

_Note: All commands must be run from your workspace directory_

## Bringup the hand
Determine what config profile to use (we'll use "**anthro7**" for these tutorials)

- Start the hand control server (based on [pressure_control_ros](https://github.com/cbteeple/pressure_control_cbt) package)
    - `roslaunch hand_arm hand_bringup.launch profile:=anthro7`



## Bringup the arm
Before you can control the robot arm, you first need to start some ROS servers.

- Start roscore
    - `roscore`
- Start the robot control server
    - `roslaunch ur_modern_driver ur5e_bringup.launch limited:=true robot_ip:=192.168.1.2`
- Start [MoveIt!](http://docs.ros.org/kinetic/api/moveit_tutorials/html/index.html) (**This is only nessecary if you're planning trajectories in cartesian space**)
    - With the real robot
        - `roslaunch ur5_e_moveit_config ur5_e_moveit_planning_execution.launch limited:=false`
        - `roslaunch ur5_e_moveit_config moveit_rviz.launch config:=true `
    - With a simulated robot
        - `roslaunch ur_e_gazebo ur5e.launch`
        - `roslaunch ur5_e_moveit_config ur5_e_moveit_planning_execution.launch sim:=true`
        - `roslaunch ur5_e_moveit_config moveit_rviz.launch config:=true`


## Bringup the data recording service
By default, data is recorded in ROS's "bag" format, which is hard to interact with later. Instead, you should pickle the data so that it can be efficiently stored and processed later:

`roslaunch rosbag_recorder rosbag_recorder.launch pickle:=true`

_(Note, pickling could take a long time if you're saving large amounts of data)_




### Automate the bringup process
If you don't want to start all of these programs independently, you can write some bash scripts to start everything. Write a few scripts in your main workspace folder:

#### Bringup all hardware
This script starts the ROS servers that handle the arm, hand, and data saving. If you just want to run some trajectories that are already built and planned, you only need these running.

`bringup-hw.sh`

```bash
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
```

#### Bringup the planning interface
If you need to build and plan tajectories, you need to start MoveIt! and RViz in addition to bringing up the hardware.

`bringup-planning.sh`

```bash
#!/bin/bash

roslaunch ur5_e_moveit_config ur5_e_moveit_planning_execution.launch limited:=false &
sleep 1
roslaunch ur5_e_moveit_config moveit_rviz.launch config:=true &
sleep 1

wait $(jobs -p)
```




#### Build and plan all at once
The build and plan steps incolve typing the trajectory name for both. This script allows you to build, then plan all at once.

`pick-place-build-plan.sh`

```bash
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
```

Now you've reduced the bringup process for the arm and hand to only **one command**, with two additional commands when you need to build and plan:

```bash
bash bringup-hw.sh anthro4
bash bringup-planning.sh
bash pick-place-build-plan.sh example/2finger_grid
```



