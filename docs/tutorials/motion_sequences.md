---
layout: default
title: Motion Trajectories
parent: Basic Tutorials
permalink: /tutorials/motion_trajectories
nav_order: 3
---

# {{ page.title }}

1. TOC
{:toc}


---

## Trajectory definitions

Each trajectory definition encodes a sequence of operations (coordinated arm motions and gripper actions), where operations draw semantically from a pool of "_moves_" for each device. "_Moves_" take the form of lists of arm poses or gripper commands.

Trajectories are defined in "_*.yaml_" files. There are three main components:
- **arm**: a dictionary of moves, where each move is defined as a list of waypoints (either in joint space or cartesian space)
- **hand**: a dictionary of moves, where each move is defined as a list of pressure waypoints
- **sequence**: A dictionary defining how moves go together
    - **operations**: A list of operations (coordinated arm motions and gripper actions)
    - **setup**: The definitions of what spaces moves are defined in
    - **startup**: The moves to execute on startup



#### Example arm definition
```yaml
arm:
    move0:
      - joints_pos: [0.55194091796875, -1.1657193464091797, 0.8279197851764124, -0.0856812757304688,
        1.2985548973083496, -1.1019604841815394]
        time: 0.0

      - joints_pos: [0.8256011009216309, -1.4658101362041016, 2.48220664659609, -1.0026353162578125,
        0.9288854598999023, -1.07166034380068] #[radians]
        time: 5.0

    move1:
      - joints_pos: [0.8256011009216309, -1.4658101362041016, 2.48220664659609, -1.0026353162578125,
        0.9288854598999023, -1.07166034380068] #[radians]
        time: 0.0
    ...
```


#### Example hand definition
```yaml
hand:
    grasp:
      - [0.0, 0.0, 0.0, 0.0, 0.0]     #[sec  psi  psi  pos  psi]
      - [2.0, 15.0, 0.0, 15.0, 0.0]   #[sec  psi  psi  psi  psi]
      - [3.0, 15.0, 0.0, 15.0, 0.0]   #[sec  psi  psi  psi  psi]

    release:
      - [0.0, 15.0, 0.0, 15.0, 0.0]   #[sec  psi  psi  psi  psi]
      - [2.0, 0.0, 0.0, 0.0, 0.0]     #[sec  psi  psi  psi  psi]
      - [3.0, 0.0, 0.0, 0.0, 0.0]     #[sec  psi  psi  psi  psi]

    startup:
      - [0.0, 0.0, 0.0, 0.0, 0.0]     #[sec  psi  psi  psi  psi]
      - [0.0, 0.0, 0.0, 0.0, 0.0]     #[sec  psi  psi  psi  psi]
```


#### Example sequence
```yaml
sequence:
    operations:
      - {arm: move0,   hand: startup} # Perform the startup move
      - {arm: false, hand: grasp}     # Grasp
      - {arm: move1,  hand: false}    # Do the first arm move
      - {arm: false, hand: release}   # Release
      - {arm: move2,  hand: false}    # Do the second arm move

    # Define the coodinate space the trajectories are built in
    setup:
        arm_traj_space: joint     # options: joint, cartesian
        hand_traj_space: pressure # options: pressure, robotiq
    
    # Define the trajectory subcomponents to use at the beginning
    startup:
        arm: move0
        hand: startup
```

#### The whole file

"_trajectories/examples/manually_built/**joint_traj.yaml**_"

[<i class="fab fa-github"></i> "joint_traj.yaml" on GitHub]( https://github.com/cbteeple/hand_arm_cbt/blob/master/trajectories/examples/manually_built/joint_traj.yaml ){: .btn .btn-primary} 


## Set up arbitrary motion routines manually:

1. Create a yaml file similar to the ones in "trajectories"
    - For example, take a look at "[_trajectories/examples/manually_built/**manually_built.yaml**_](https://github.com/cbteeple/hand_arm_cbt/blob/master/trajectories/examples/manually_built/manually_built.yaml)" in a text editor

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


## Plan Trajectories

`roslaunch hand_arm plan-traj.launch traj:=[VALUE]`
{: .fs-5}

- **traj** (`str`): The trajectory or group of trajectories to plan
    - To plan a single trajectory definition, set `traj` to a filename (_must end in "*.yaml"_).
    - To plan a whole subcollection of trajectories, set `traj` to the name of the containing folder.

Once you have a trajectory set up, you need to run it through the planning step to convert arm trajectories to joint space. If arm moves are defined in cartesian space, we need to run motion planning on them using MoveIt!. If arm moves are defined in joint space already, they just get coppied.

_If your arm moves are defined in terms of cartesian waypoints, the arm and MoveIt! must both be running (see [System Startup]({{ site.baseurl }}{% link docs/tutorials/system_startup.md %}))._



#### Example

`roslaunch hand_arm plan-traj.launch traj:=examples/joint_traj`


## Run Trajectories
`roslaunch hand_arm run-traj.launch config:=[VALUE] traj:=[VALUE]`
{: .fs-5}

- **config** (`str`): Name of the run config file (must be stored in "_config/run_configs_")
- **traj** (`str`): Trajectory or group of trajectories to plan
    - To run a single trajectory definition, set `traj` to a filename (_must end in "*.yaml"_)
    - To run a whole groups of trajectories, set `traj` to the name of the containing folder
- **save** (`bool`, default=True): Decide whether to save data
- **id** (`str`, default=""): ID of the run used to organized saved data
- **reps** (`int`, default=1): Number of times to repeat each trajectory
- **start** (`int`, default=0): Trajectory index to start at (_only valid when running groups of trajectories_)
- **use_checklist** (`bool`, default=True): Use the success checklist (prompts after every rep)
- **speed_factor** (`float`, default=1.0): Speed multiplier - _values larger than 1.0 run the trajectory faster_


### Set up run config files

Run config files set up which hardware is being used, and whether or not to use the camera for apriltag detection. Here is a typical run config file:

"_config/**run_configs/hand_arm.yaml**_"

[<i class="fab fa-github"></i> "run_configs/hand_arm.yaml" on GitHub]( https://github.com/cbteeple/hand_arm_cbt/blob/master/config/run_configs/arm_hand.yaml ){: .btn .btn-primary} 


```yaml
# Set up devices to use
use_arm: True
use_hand: True
use_servo: False

# Set up video and april tags
use_camera: False
use_tags: False
```


#### Trajectory Run Examples

1. Run the "_joint_traj_" trajectory
    - `roslaunch hand_arm run-traj.launch config:= hand_arm.yaml  traj:=examples/joint_traj/joint_traj.traj`
2. Run the "_2finger_grid_" trajectory group
    - `roslaunch hand_arm run-traj.launch config:= hand_arm.yaml traj:=examples/2finger_grid`



## Directory Structure

Trajectory definitions must be saved in the "**trajectories**" folder, and follow a specific nesting format:

1. When you build single trajectories manually, each trajectory definition should be in its own folder.
    - _The actual filename of the "*.yaml" file doesn't matter, but good convention is to name the trajectory the same as the folder._
2. If you want to manually build a set of trajectories, you may place them all in the same folder.
    - _When planning and running trajectories, you can either choose to run individual files, or run the whole folder._
3. When trajectories are built from a pick-and-place definition, a folder of trajectories is generated.
    - The filename of the pick-and-place definiton becomes the folder name, and auto-generated trajectory definitions have auto-generated filenames.
    - _See the [Pick And Place]({{ site.baseurl }}{% link docs/pick_and_place/pick_and_place.md %}) section for details._

#### Example of good nesting

```bash
hand_arm # The root folder of this package
└── trajectories # Where all trajectories are stored
    └── examples # A collection of example trajectories
        └── manually_built # The "manually_built" folder
        │   └── manually_built.yaml # The "manually_built" trajectory definition
        │
        └── joint_traj # The "joint_traj" folder
        │   └── joint_traj.yaml # The "joint_traj" trajectory definition
        │
        └── 2finger_single # A subcollection of trajectories built from a pick-and-place definiton
        │   └── pos_0000.yaml # A single trajectory definition inside this collection
        │
        └── 2finger_grid # A subcollection of trajectories built from a pick-and-place grid definiton
            └── pos_0000.yaml # The trajectory for the 1st position in the grid
            └── pos_0001.yaml # The trajectory for the 2nd position in the grid
            ...
            └── pos_0030.yaml # The trajectory for the 31st position in the grid
```