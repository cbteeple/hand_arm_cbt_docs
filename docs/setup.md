---
layout: default
title: Setup
has_children: false
permalink: setup
nav_order: 2
---


# {{ page.title }}


## Dependencies
### Hardware:
- A pressure control system running my [custom firmware](https://github.com/cbteeple/pressure_controller)
- A robot arm (currently tested only with a UR5e)
- A desktop computer running Linux (currently tested only in [Ubuntu 18.04](https://ubuntu.com/download/desktop))

### Software:
- [ROS Melodic](http://wiki.ros.org/melodic/Installation)
	- My [pressure_control_cbt](https://github.com/cbteeple/pressure_control_cbt) package for ROS
	- My version of [rosbag_recorder](https://github.com/cbteeple/rosbag-recorder) for ROS
	- The [ur_modern_driver](https://github.com/plusone-robotics/ur_modern_driver/tree/add-e-series-support) ROS package with e-series support (by plusone robotics)
	- The [bond](https://github.com/ros/bond_core) package for ROS
	- [ROS Industrial](http://wiki.ros.org/Industrial/Install) package `apt-get install ros-melodic-industrial-core`
	- [MoveIt!](http://docs.ros.org/kinetic/api/moveit_tutorials/html/index.html) motion planning package
- Various python libraries:
	- [scipy](https://www.scipy.org/) (`pip install scipy`)
	- [numpy](https://www.numpy.org/) (`pip install numpy`)
	- [numbers](https://docs.python.org/2/library/numbers.html) (`pip install numbers`)
	- [matplotlib](https://matplotlib.org/) (`pip install matplotlib`)
	- [pynput](https://pypi.org/project/pynput/) (`pip install pynput`)
	- [yaml](https://pyyaml.org/wiki/PyYAMLDocumentation) (`pip install pyyaml`)
	
## Installation
1. This is a ROS package, so you should be working out of a [catkin workspace](http://wiki.ros.org/catkin/workspaces)
1. Add this package to your `[WORKSPACE NAME]/src` folder.
2. In a new terminal, run `catkin_make` from your workspace directory to enable the custom python modules in this package to work


## Usage
This package enables basic robot motion, and coordination of the arm with the hand. See the [Tutorials](/tutorials) section for step-by-steps.