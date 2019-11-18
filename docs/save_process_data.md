---
layout: default
title: Save & Process Data
permalink: /save_process_data
nav_order: 5
font_awesome: "fas fa-chart-bar"
---

# <i class="{{ page.font_awesome }}"></i> {{ page.title }}

1. TOC
{:toc}

---

## Record Data
### Start the recording service
- Start the service using the launch file. You also want to pickle the data for easier access later
	- `roslaunch rosbag_recorder rosbag_recorder.launch pickle:=true`
	- _(Note, pickling could take a long time if you're saving super large amounts of data)_


### Start/Stop recording
When you run a pick-and-place operation, add the `save:=true` argument:

`roslaunch hand_arm pick-place-run-multi.launch traj:=examples/2finger_grid save:=true`

This uses the ROS service protocol to record data on the relevant ROS topics (see [rosbag_recorder documentation](https://github.com/cbteeple/rosbag-recorder) for more detailed description)


## Process the data later
If you pickled your data after saving, you can use another set of scripts to plot them. This takes care of sorting through the mess of a dictionary that ROS creates when saving data.

[rosbag-pickle-graph](https://github.com/cbteeple/rosbag-pickle-graph){: .btn .btn-primary}

`python graph_robot.py ft/up200_11162019_210947`

<img src="{{ site.url }}{{ site.baseurl }}/assets/img/rosbag-pickle-graph-example.svg"/>
