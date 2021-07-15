---
layout: default
title: Basic Moves
parent: Basic Tutorials
permalink: /tutorials/basic_moves
nav_order: 2
---

# {{ page.title }}

1. TOC
{:toc}

---

## Move the arm to specified joint positions
{: .d-inline-block}

Important
{: .label .label-yellow .fs-3}

{: .fs-5}
`rosrun hand_arm move_simple.py [COMMAND] [ARG]`

With a simple `rosrun` command, you can set named arm positions using teach mode.


| Command  |  Arg    |   Description |
| :----:   | :---    | :---   |
| **goto**        | position_name (_str_) | Move the arm to a saved position.|
| **set**         | position_name (_str_) | Set and store the arm's position. _This enable's freedrive mode so you can push the arm to a desired pose before saving._ |
| **setnow**      | position_name (_str_) | Set and store the arm's current position.|
| **list**        | _n/a_ | List the names and values of all saved poses|
| **listnames**   | _n/a_ | List the names of all saved poses|


#### Examples: 
- `rosrun hand_arm move_simple.py goto zero` - Move to the zero position (straight up)
- `rosrun hand_arm move_simple.py set home` - Set the home position
- `rosrun hand_arm move_simple.py goto home` - Move to the home position
- `rosrun hand_arm move_simple.py list` - List out all the saved poses

Positions get saved in **config>>arm_poses.yaml**, so you can add/edit that file directly if you want.


## Teach trajectories using freedrive mode
When using teach mode, the robot will be put into freedrive mode, enabling you to push it around.

### Enable freedrive mode without saving anything

`rosrun hand_arm teach.py`
{: .fs-5}

If you just need to push the arm into a configuration before you start other operations, this is how to do it.

### Teach a trajectory from start to finish

`rosrun hand_arm teach.py [FILENAME]`
{: .fs-5}

Save a trajectory continuously at a rate of 20Hz. _This option is meant for debugging, but maybe it's useful for other things._


### Teach a trajectory via individual waypoints:
{: .d-inline-block}

Important
{: .label .label-yellow .fs-3}

`rosrun hand_arm teach_points.py [FILENAME] [FLAGS]`
{: .fs-5}

Teach the robot using waypoints. Waypoints are saved in joint space, and hand moves are saved in pressure space.

- **filename:** Name of the file to save the trajectory to.
- **flags:** flags for specific options
    - **cartesian:** Use cartesian end effector poses rather than joint angles. (_requires MoveIt! to be running_)
    - **robotiq:** Use a robotiq 2F gripper rather than a pressure controlled hand. (_requires [robotiq_trajectory_control](https://github.com/cbteeple/robotiq_2f_trajectory_control) package_)

Once running the command, you can use keyboard commands to save trajectory points and control your gripper:

| Command      | Function |
| :---:        |    :----   |
| <kbd>Space</kbd> | Save the current pose as a waypoint in the trajectory |
| <kbd>Shift</kbd> | Toggle continuous capture of poses on/off |
| <kbd>F</kbd> | Toggle freedrive mode |
| <kbd>G</kbd> | Perform a grasp |
| <kbd>R</kbd> | Release the grasp |
| <kbd>Ctrl</kbd> + <kbd>C</kbd> | End the program and save the trajectory |

#### Example:

Teach a trajectory called "**test_move**", and put it in the "**testing**" folder:

1. `rosrun hand_arm teach_points.py testing/test_move`
2. Use keyboard commands to add waypoints, grasps, and releases to the trajectory
3. Use _Ctrl+C_ to end. The trajectory is then saved:
   - "_trajectories/.arm/**testing/test_move**/trajectory.yaml_"
   - After saving, the trajectory is automatically "planned" (i.e. converted to a ".traj" file) for playback.

## Replay a trajectory:
{: .d-inline-block}

Important
{: .label .label-yellow .fs-3}

{: .fs-5}
```bash
roslaunch hand_arm run-traj-taught.launch config:=arm_hand.yaml \
    traj:=[FILENAME]  speed_factor:=[SPEED FACTOR]  reps:=[NUM REPS]
```

"speed factor" is a multiplier on the speed (i.e. 0.5 is half speed, 2.0 is double). _If you increase the speed, the robot becomes less accurate (i.e. it's not able to move fast enough to get to every waypoint). **Use the speed factor at your own risk**_

#### Example:

Run the "**testing/test_move**" trajectory you taught:

```bash
roslaunch hand_arm run-traj-taught.launch config:=arm_hand.yaml \
    traj:=testing/test_move
```


