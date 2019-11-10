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

### Do this in separate terminals
This allows you to debug better since you can see error messages from each major program independently.
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

### Write a bash script
If you don't want to start all of these programs independently, you can write a bash script to start everything. Write a script called "arm_bringup.sh" in your main workspace folder:
```bash
roscore &
sleep 0.5
roslaunch ur_modern_driver ur5e_bringup.launch limited:=true robot_ip:=192.168.1.2 &
sleep 0.5
roslaunch ur5_e_moveit_config ur5_e_moveit_planning_execution.launch limited:=false &
sleep 0.5
roslaunch ur5_e_moveit_config moveit_rviz.launch config:=true &
wait
echo 'All UR5e servers are finished'
```

Now you've reduced the bringup process for the arm to just one command:
```bash
bash launch_all.sh
```
