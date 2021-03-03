---
layout: default
title: Basic Moves
parent: Tutorials
permalink: /tutorials/basic_moves
nav_order: 2
---

# {{ page.title }}

---

## Arm
### Move the arm to specified joint positions:
Move to zero:
`rosrun hand_arm move_home.py go 0`

Move to home:
`rosrun hand_arm move_home.py go 1`


Move to some other stored position:
`rosrun hand_arm move_home.py go [POSITION_NUMBER]`


Set a position (*all but the zero position can be set*):
`rosrun hand_arm move_home.py set [POSITION_NUMBER]`




### Teach the arm:
When using teach mode, the robot will be put into freedrive mode, enabling you to push it around.

- Enable freedrive mode without saving anything:
   - `rosrun hand_arm teach.py`

- Teach the entire trajectory from start to finish 
   - `rosrun hand_arm teach.py [FILENAME]`

- Teach individual waypoints in a trajectory:
   - `rosrun hand_arm teach_points.py [FILENAME]`
   - In this mode, use the space bar to save the current position as a point in the trajectory.

- Replay a trajectory:
   - `rosrun hand_arm replay.py [FILENAME] [SPEED FACTOR]`
   - "speed factor" is a multiplier on the speed (i.e. 0.5 is half speed, 2.0 is double). _If you increase the speed, the robot becomes less accurate (i.e. it's not able to move fast enough to get to every waypoint). **Use the speed factor at your own risk**_


### Run a trajectory on the arm
   - `roslaunch hand_arm arm-traj.launch traj:=[FILENAME] reps:=[# REPS]` (Not yet implemented)



## Hand
Run a trajectory on the arm (2-step process)
1. Load the trajectory to the onboard buffer
   - `roslaunch pressure_controller_ros load_traj.launch profile:=example/planar2seg_demo`
2. Run the trajectory
   - `roslaunch pressure_controller_ros run_traj.launch`
   - Press space to restart the trajectory
   - Press shift to pause.
