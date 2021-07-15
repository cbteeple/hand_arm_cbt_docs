---
layout: default
title: System Startup
parent: Basic Tutorials
permalink: /tutorials/system_startup
nav_order: 1
---

# {{ page.title }}

1. TOC
{:toc}

---

## Bringup Commands
_Note: All commands must be run from your workspace directory_

### Start ROS
`roscore`
{: .fs-5}

You always need to start with `roscore`


### Bringup the arm

`roslaunch ur_modern_driver ur5e_bringup.launch limited:=true robot_ip:=[IP]`
{: .fs-5}

Before you can control the robot arm, you first need to start some ROS servers.

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

### Bringup the hand

`roslaunch hand_arm hand_bringup.launch profile:=[PROFILE]`
{: .fs-5}

Determine what config profile to use (we'll use "**anthro7**" for these tutorials)

- Start the hand control server (based on [pressure_control_ros](https://github.com/cbteeple/pressure_control_cbt) package)
    - `roslaunch hand_arm hand_bringup.launch profile:=anthro7`


### Bringup the data recording service

`roslaunch rosbag_recorder rosbag_recorder.launch pickle:=true`
{: .fs-5}

By default, data is recorded in ROS's "bag" format, which is hard to interact with later. Instead, you should pickle the data so that it can be efficiently stored and processed later.

_(Note, pickling could take a long time if you're saving large amounts of data)_




## Automate the bringup process
If you don't want to start all of these programs independently, you can write some bash scripts to start everything. Write a few scripts in your main workspace folder:

### Bringup all hardware

`bash bringup-hw.sh [HW_PROFILE] [CONFIG_PROFILE]`
{: .fs-5}

This script starts the ROS servers that handle the arm, hand, and data saving. If you just want to run some trajectories that are already built and planned, you only need these running.

**Example:** `bash bringup-hw.sh hid1 anthro8`

[<i class="fas fa-file-alt"></i> bringup-hw.sh]( {{ "assets/files/bringup-hw.sh" | absolute_url }} ){: .btn}


```bash
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
```


### Bringup the planning interface

`bash bringup-planning.sh [HW_PROFILE]`
{: .fs-5}

If you need to build and plan tajectories, you need to start MoveIt! and RViz in addition to bringing up the hardware.


**Example**
- UR5e: `bash bringup-planning.sh ur5_e`
- [UR5e with soft hand](https://github.com/cbteeple/ur5e_hardware_config): `bash bringup-planning.sh ur5e_with_soft_hand`

[<i class="fas fa-file-alt"></i> bringup-planning.sh]( {{ "assets/files/bringup-planning.sh" | absolute_url }} ){: .btn}


```bash
#!/bin/bash

roslaunch ${1}_moveit_config ${1}_moveit_planning_execution.launch limited:=false &
sleep 1

roslaunch ${1}_moveit_config moveit_rviz.launch config:=true &
sleep 1

wait $(jobs -p)
```




### Build and plan all at once

`bash pick-place-build-plan.sh [TRAJECTORY]`
{: .fs-5}

The build and plan steps incolve typing the trajectory name for both. This script allows you to build, then plan all at once.

[<i class="fas fa-file-alt"></i> pick-place-build-plan.sh]( {{ "assets/files/pick-place-build-plan.sh" | absolute_url }} ){: .btn}


```bash
#!/bin/bash

if [ "$1" != "" ]; then
	roslaunch hand_arm pick-place-build-multi.launch traj:=$1
	wait
	echo "Done Building"
	roslaunch hand_arm plan_traj.launch traj:=$1
	wait
	echo "Done Planning"
else
    echo "Please input a trajectory to build/plan"
fi
```

### The result: easy quick-start
Now you've reduced the bringup process for the arm and hand to only **one command**, with two additional commands when you need to build and plan:

```bash
bash bringup-hw.sh anthro4
bash bringup-planning.sh
bash pick-place-build-plan.sh example/2finger_grid
```



