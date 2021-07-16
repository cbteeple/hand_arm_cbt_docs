---
layout: default
title: Definition Setup
permalink: pick_and_place/setup
parent: Pick and Place
nav_order: 1
---

# {{ page.title }}

1. TOC
{:toc}

---

Pick-and-place routines are simple opterations with a few key parts which are built into a standard motion trajectory.
{: .fs-5 .fw-300 }

## Parts of a pick-and-place routine

A pick and place task has 5 main components:
1. **Set up move**
2. **Grasp**
3. **Manipulate**
4. **Release**
5. **Move to end**


### Settings
Settings consist of several options related to hardware and action configuration.

- **type** (`str`): The type of pick and place action.
	- Options are _single_ or _grid_.
- **use_arm** (`bool`):  Decide whether or not the arm is used in this trajectory
- **use_hand** (`bool`):  Decide whether or not the hand is used in this trajectory
- **reset_object** (`bool`):  Reset the object after the pick-and-place task is complete. Essentially just a reversal of the resulting trajectory


#### Example
```yaml
settings:
  boomerang: true
  reset_object: true
  type: grid # options: single, grid
  use_arm: True
  use_hand: True
```


### Arm
Define specific important poses, how the object is picked up, and define a grid over which to make permutations

- **orientation_type** (`str`): How orientations are defined in poses. All orientations in the config file must be defined in the same units.
	- Options are _quaternions_, _radians_, or _degrees_.
- **initial_pose** (`dict`): The pose to start at
- **grasp_pose** (`dict` or `list`): The pose or list of poses to use during the grasp portion of the task
	- If a single pose is provided, the arm moves stright from the initial pose to the grasping pose.
- **release_pose** (`dict` or `list`): The pose or list of poses where the object is released.
- **final_pose** (`dict`): The ending pose.
- **pickup**:
	- **type** (`str`): The type of pickup action to perform. Options are _square_, _triangle_, and _to_pose_.
	- **args** (`dict`): Arguments to give to the pickup builder. These depend on the type (as described later).
- **grid**:
	- **num_pts** (`list`): List of number of grid points to make in all cartesian dimensions.
	- **dims** (`list`): Dimensions of the grid of grasping poses in all cartesian dimensions.
	- **release_dims** (`list`): Dimensions of the grid of release poses in all cartesian dimensions.
	- **affects_release_pose** (`bool`): Choose if the grid should affect the release pose.


**Optional addons:**
- **manip_pose_before** (`list`): A list of poses to execute between the _grasp_ and _manipulate_ steps
- **manip_pose_after** (`list`): A list of poses to execute between the _manipulate_ and _release_ steps
- **manip_sequence** (`list`): Add a long list of poses to the _manipulate_ step.
	- **type** (`str`): The type of sequence. Currently _trajectory_ is the only option.
	- **args**: Arguments to give to the manipu sequence builder
		- **trajectory** (`str`): Filename where the trajectory is stored.
		- **sequence** (`list`): Sequence of moves (as defined in the trajectory file).


#### Example

```yaml
arm:
  orientation_type: 'degrees' # options: 'quaterions', 'radians, 'degrees'

  initial_pose:
    position: [0.55, 0.30, 0.20]
    orientation: [0,90,0]

  grasp_pose:
    - position: [0.55, 0.30, 0.20]
      orientation: [0,90,0]
    - position: [0.55, 0.30, 0.065]
      orientation: [0,90,0]

  ... # Define all other poses similarly to this.


  pickup:
    type: to_pose # square, triangle, to_pose
    args:
      before: 'manip_pose_before'
      after: 'manip_pose_after'

  manip_sequence:
    type: 'trajectory'
    args:
      trajectory: 'manip/armando_simple.yaml'
      sequence:   [path0, path1, path2, path3, path4, path5, path6, path7, path8, path9, path10, path11, path12, path13]

  grid:
    num_pts: [1,1,1] # Number of points on each side [number] in (x, y, z) order
    dims: [0,0,0]    # Dimension of each grid side [meters] in (x, y, z) order
    release_dims: [0,0,0]
    affects_release_pose: True
```


### Hand
Define specific hand pressures and skills

- **num_channels** (`int`): Number of control channels in the hand
- **max_pressure** (`float`): Maximum pressure the hand should be commanded to
- **min_pressure** (`float`): Minimum pressure the hand should be commanded to
- **idle_pressure** (`list`): A vector of pressures that the hand should be set to when idle

#### Grasp options
- **grasp_sequence** (`dict`): Define the grasping sequence
	- **type** (`str`): The type of grasping sequence. Options are _trajectory_ or _skill_.
	- **sequence** (`list`): The pressure trajectory or list of skills to use.
- **grasp_sequence**, (_legacy definition_) (`list`):  A pressure trajectory to use. Just use the list directly.

#### Manipulation options
- **manip_sequence** (`dict`): Define the in-hand manipulation sequence
	- **type** (`str`): The type of manipulation sequence. Options are _trajectory_ or _skill_.
	- **sequence** (`list`): The pressure trajectory or list of skills to use.
- **manip_sequence**, (_legacy definition_) (`list`):  A pressure trajectory to use. Just use the list directly.

_`manip_sequence` may be ommited if not needed_

#### Release options
- **release_sequence** (`dict`): Define the release sequence
	- **type** (`str`): The type of release sequence. Options are _trajectory_ or _skill_.
	- **sequence** (`list`): The pressure trajectory or list of skills to use.
- **release_sequence**, (_legacy definition_) (`list`):  A pressure trajectory to use. Just use the list directly.

## Example

Pick and place setup files should be located in "**_traj_setup_**".

