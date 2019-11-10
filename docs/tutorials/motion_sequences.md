---
layout: default
title: Coordinated Motion Sequences
parent: Tutorials
permalink: /tutorials/motion_sequences
nav_order: 3
---

# {{ page.title }}


---

## Set up arbitrary motion routines manually:

1. Create a yaml file similar to the ones in "trajectories"
	- For example, take a look at "**_trajectories/examples/manually_built/manually_built.yaml_**" in a text editor

2. Set up arm trajectories
	- Joint Space
		- In *sequence* >> *setup*, change the *arm_traj_space* to "*joint*"
		- In *arm*, set up each move segment by naming it
		- Use a list of joint positions and times to create joint trajectories for each move segment

	- Cartesian Space (End effector poses)
		- In *sequence* >> *setup*, change the *arm_traj_space* to "*cartesian*"
		- In *arm*, set up each move segment by naming it
		- Use a list of end effector positions and orientations to create pose waypoints for each move segment

3. Set up hand trajectories
	- In *sequence* >> *setup*, set the *hand_traj_space* to "*pressure*"
	- In *hand*, set up each move segment by naming it
	- Use a list of trajectory points in the following form: 
		- `[time, p1, p2, ..., pn ]` where time is in seconds and *p1* - *pn* are pressures in psi

4. Set up the motion sequence
	- Each line of the sequence should have an *arm* and *hand* entry. If no trajectory segment should be used, set it to *false*
	- In *sequence* >> *startup*, set the startup trajectory segments for each device
	- In *sequence* >> *operations*, set the sequence of trajectory segments to use. These should be the exact names of segments you entered before.