---
layout: default
title: Setup
has_children: false
permalink: setup
nav_order: 2
font_awesome: "fas fa-cog"
---


# <i class="{{ page.font_awesome }}"></i> {{ page.title }}


## Dependencies
### Hardware:
- A pressure control system running my [Ctrl-P Firmware](https://github.com/cbteeple/pressure_controller)
- A UR robot arm (currently tested only with a UR5e, but should work with other variants)
- A desktop computer running Linux (currently tested only in [Ubuntu 18.04](https://ubuntu.com/download/desktop))

### Software:
- [ROS Melodic](http://wiki.ros.org/melodic/Installation)
	- The [ur_modern_driver](https://github.com/plusone-robotics/ur_modern_driver/tree/add-e-series-support) ROS package with e-series support (by plusone robotics)
	- My [ROS Driver for Ctrl-P](https://github.com/cbteeple/pressure_control_cbt)
	- [ROS Industrial](http://wiki.ros.org/Industrial/Install) package `apt-get install ros-melodic-industrial-core`
	- [MoveIt!](http://docs.ros.org/kinetic/api/moveit_tutorials/html/index.html) motion planning package
	- My version of [rosbag_recorder](https://github.com/cbteeple/rosbag-recorder) for saving data in ROS
	- My version of [ros_video_recorder](https://github.com/cbteeple/ros_video_recorder) for saving videos in ROS
	- My [rosbag-pickle-graph](https://github.com/cbteeple/rosbag-pickle-graph) package for processing saved data
- Various python libraries:
	- All python dependencies are managed in the reqirements file. `pip install -r requirements.txt`
	
## Installation

[Download the ROS Package](https://github.com/cbteeple/hand_arm_cbt){: .btn .btn-primary}

1. This is a ROS package, so you should be working out of a [catkin workspace](http://wiki.ros.org/catkin/workspaces)
2. Add this package to your `[WORKSPACE NAME]/src` folder.
3. Inside the root folder of this package, install python requirements: `pip install -r requirements.txt`
4. In a new terminal, run `catkin_make` from your workspace directory to enable the custom python modules in this package to work.


## Usage
This package enables basic robot motion, teach mode, and coordination of the arm with the hand. See the [Tutorials](tutorials) section for step-by-steps.