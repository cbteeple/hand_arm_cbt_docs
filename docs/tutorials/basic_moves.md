---
layout: default
title: Basic Moves
parent: Basic Tutorials
permalink: /tutorials/basic_moves
nav_order: 2
---

# {{ page.title }}

---

## Move the arm to specified joint positions
With a simple command, you can set named arm positions using teach mode.

- Set/store a position:
   - `rosrun hand_arm move_home.py set [POSITION_NAME]`
- Move to a stored position:
   - `rosrun hand_arm move_home.py go [POSITION_NAME]`

### Examples: 
- Move to the zero position (straight up):
   - `rosrun hand_arm move_home.py go zero`
- Set the home position:
   - `rosrun hand_arm move_home.py set home`
- Move to the home position:
   - `rosrun hand_arm move_home.py go home`

These positions get saved in **config>>arm_poses.yaml**, so you can add/edit that file directly if you want.




## Teach the arm in joint space
When using teach mode, the robot will be put into freedrive mode, enabling you to push it around.

### Enable freedrive mode without saving anything
`rosrun hand_arm teach.py`

### Teach the entire trajectory from start to finish 
`rosrun hand_arm teach.py [FILENAME]`

### Teach individual waypoints in a trajectory:
`rosrun hand_arm teach_points.py [FILENAME] [FLAGS]`

Teach the robot using waypoints. Waypoints are saved in joint space, and hand moves are saved in pressure space.

- **filename:** Name of the file to save the trajectory to.
- **flags:** flags for specific options
    - **cartesian:** Use cartesian end effector poses rather than joint angles. (_requires MoveIt! to be running_)
    - **robotiq:** Use a robotiq 2F gripper rather than a pressure controlled hand. (_requires [robotiq_trajectory_control](https://github.com/cbteeple/robotiq_2f_trajectory_control) package_)

Once running the command, you can use keyboard commands to save trajectory points and control your gripper:

| Command      | Function |
| :---:        |    :----   |
| <kbd>Space</kbd> | Save the current pose as a point in the trajectory |
| <kbd>Shift</kbd> | Toggle continuous capture of poses on/off |
| <kbd>G</kbd> | Perform a grasp |
| <kbd>R</kbd> | Release the grasp |

### Replay a trajectory:
   - `rosrun hand_arm replay.py [FILENAME] [SPEED FACTOR]`
   - "speed factor" is a multiplier on the speed (i.e. 0.5 is half speed, 2.0 is double). _If you increase the speed, the robot becomes less accurate (i.e. it's not able to move fast enough to get to every waypoint). **Use the speed factor at your own risk**_


