---
layout: default
title: Pick-and-Place
parent: Tutorials
permalink: /tutorials/pick_place
nav_order: 4
---

# {{ page.title }}

1. TOC
{:toc}

---

We will use the files located in "**_traj_setup/examples_**" and "**_trajectories/examples_**". When you pass the names of these files to ROS in the `roslaunch` command, you never need to use file extensions.

Pick-and-place routines are just a specific ordering of [coordinated motion sequences](/tutorials/motion_sequences)

## Define Waypoints in Cartesian Space
You can set up pick-and-place routine using cartesian poses, then use MoveIt! to do the IK and motion planning. 

1. Build a routine
	- Open the following YAML files in a text editor
		- "**_traj_setup/examples/2finger_single.yaml_**" (building a single pick-and-place action)
		- "**_traj_setup/examples/2finger_grid.yaml_**" (building a grid of pick-and-place actions in space)
	- Set the poses and grasping settings you want to use.
	- `roslaunch hand_arm pick-place-build-multi.launch traj:=examples/2finger_single` Build a single trajectory
	- `roslaunch hand_arm pick-place-build-multi.launch traj:=examples/2finger_grid` Build a family of trajectories

2. Plan a routine
	- _This requires that you bring up the robot and start MoveIt! See [System Startup](/tutorials/system_startup). One the planning step is finished, you don't need MoveIt! running._
	- Plan a single trajectory: `roslaunch hand_arm pick-place-plan-multi.launch traj:=examples/2finger_single`
	- Plan a grid: `roslaunch hand_arm pick-place-plan-multi.launch traj:=examples/2finger_grid` Build a family of trajectories
	- These commands use MoveIt! to plan trajectories based on poses, then save the resulting joint-space trajectories.

3. Run a planned routine
	- Run a single trajectory: `roslaunch hand_arm pick-place-run-multi.launch traj:=examples/2finger_single reps:=[# REPS]`
		- **traj** (_required_) the filename of a single trajectory (no .yaml extension)
		- **reps** (_optional_, default: 1) Number of reps to perform
		- **save** (_optional_, default: false) Save data for each rep of the trajectory, then pickle them

	- Run a grid: `roslaunch hand_arm pick-place-run-multi.launch traj:=examples/2finger_grid`
		- **traj** (_required_) the folder name of a grid.
		- **reps** (_optional_, default: 1) Number of reps to perform
		- **start** (_optional_, default: 0) The permutation index to start at
		- **save** (_optional_, default: false) Save data for each rep of each trajectory, then pickle them
		

Other optional things:
- Run a live routine (this replans, but doesn't save)
	- `roslaunch hand_arm pick-place-run.launch traj:=[FILENAME] reps:=[# REPS] replan:=true`

- Use some optional arguments to turn the hand or arm on/off
	- **hand** (_optional_, default: true) Use on the hand
	- **arm** (_optional_, default: true) Use on the arm


## Define Waypoints in Joint Space
You can set up pick-and-place routines using joint configurations directly. 
1. Build an routine manually
	- Open "**_trajectories/examples/manually_built/joint_traj.yaml_**" in a text editor
	- In *sequence* >> *setup*, the *arm_traj_space* is set to "*joint*"
	- In *arm*, the move segments are defined in joint positions.
	- In *hand*, the pressures are defined like normal 

2. Run the trajectory planner
	- `roslaunch hand_arm pick-place-plan.launch traj:=examples/manually_built/joint_traj`

3. Run the pick and place routine like normal.
	- `roslaunch hand_arm pick-place-run.launch traj:=examples/manually_built/joint_traj speed_factor:=1.0 reps:=20`
	