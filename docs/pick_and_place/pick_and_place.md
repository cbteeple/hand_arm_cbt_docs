---
layout: default
title: Pick and Place
permalink: pick_and_place
has_children: true
nav_order: 4
font_awesome: "fas fa-hand-pointer"
---

# <i class="{{ page.font_awesome }}"></i> {{ page.title }}

1. TOC
{:toc}

---

**(2021_07_15)**: These Instructions are now deprecated
{: .label .label-red .fs-5}



We will use the files located in "**_traj_setup/examples_**" and "**_trajectories/examples_**".

Pick-and-place routines are just a specific way of building [motion trajectories]({{ site.baseurl }}{% link docs/tutorials/motion_sequences.md %}) from a high-level config file.
{: .fs-5 .fw-300 }

## Define Waypoints in Cartesian Space
You can set up pick-and-place routine using cartesian poses, then use MoveIt! to do the IK and motion planning. 

1. Build a routine
	- Open the following YAML files in a text editor
		- "**_traj_setup/examples/2finger_single.yaml_**" (building a single pick-and-place action)
		- "**_traj_setup/examples/2finger_grid.yaml_**" (building a grid of pick-and-place actions in space)
	- Set the poses and grasping settings you want to use.
	- `roslaunch hand_arm pick-place-build.launch traj:=examples/2finger_single` Build a single trajectory
	- `roslaunch hand_arm pick-place-build.launch traj:=examples/2finger_grid` Build a family of trajectories

2. Plan a routine
	- _This requires that you bring up the robot and start MoveIt! See [System Startup]({{ site.baseurl }}{% link docs/tutorials/system_startup.md %}). One the planning step is finished, you don't need MoveIt! running._
	- Plan a single trajectory: `roslaunch hand_arm plan-traj.launch traj:=examples/2finger_single`
	- Plan a grid: `roslaunch hand_arm plan-traj.launch traj:=examples/2finger_grid` Build a family of trajectories
	- These commands use MoveIt! to plan trajectories based on poses, then save the resulting joint-space trajectories.

3. Run a planned routine
	- Use `run-traj.launch`, as discussed in the [Motion Trajectories]({{ site.baseurl }}{% link docs/tutorials/motion_sequences.md %}) section
	- Run a single trajectory: `roslaunch hand_arm run-traj.launch traj:=examples/2finger_single`

	- Run a grid: `roslaunch hand_arm run-traj.launch traj:=examples/2finger_grid`
		- **traj** (_required_) the folder name of a grid.
		- **reps** (_optional_, default: 1) Number of reps to perform
		- **start** (_optional_, default: 0) The permutation index to start at
		- **save** (_optional_, default: false) Save data for each rep of each trajectory, then pickle them
		

Other optional things:
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
	- `roslaunch hand_arm plan-traj.launch traj:=examples/manually_built/joint_traj`

3. Run the pick and place routine like normal.
	- `roslaunch hand_arm run-traj.launch traj:=examples/manually_built/joint_traj speed_factor:=1.0 reps:=20`
	