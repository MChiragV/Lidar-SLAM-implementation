## https://www.researchgate.net/figure/Multi-line-LiDAR-based-SLAM-system-structure-diagram_fig1_369950490
## https://www.researchgate.net/figure/The-LiDAR-data-preprocessing-includes-three-parts-the-keyframe-selection-a-the_fig3_351731857

# SLAM with Lidar Scans

This repository demonstrates how to implement the Simultaneous Localization And Mapping (SLAM) algorithm using a series of lidar scans. The primary goal is to build an accurate map of an environment and retrieve the trajectory of a mobile robot.

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction

This example showcases the implementation of the SLAM algorithm with pose graph optimization. The SLAM algorithm incrementally processes lidar scans to build a pose graph linking these scans. The robot recognizes previously-visited places through scan matching and establishes loop closures along its path. The SLAM algorithm uses loop closure information to update the map and adjust the estimated robot trajectory.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/slam-lidar.git
    cd slam-lidar
    ```

2. Ensure you have MATLAB installed, as this example relies on MATLAB functions and data structures.

3. Load the provided dataset:
    ```matlab
    load('offlineSlamData.mat');
    ```

## Usage

### Load Laser Scan Data from File

Load a down-sampled dataset consisting of laser scans collected from a mobile robot in an indoor environment. The dataset is stored in `offlineSlamData.mat` and contains the `scans` variable, which holds all the laser scans used in this example.

```matlab
load('offlineSlamData.mat');
```

### Run SLAM Algorithm, Construct Optimized Map, and Plot Trajectory

1. Create a `lidarSLAM` object and configure the parameters:

    ```matlab
    maxLidarRange = 8;
    mapResolution = 20;
    slamAlg = lidarSLAM(mapResolution, maxLidarRange);

    slamAlg.LoopClosureThreshold = 210;  
    slamAlg.LoopClosureSearchRadius = 8;
    ```

2. Incrementally add scans to the `slamAlg` object:

    ```matlab
    for i = 1:10
        [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(slamAlg, scans{i});
        if isScanAccepted
            fprintf('Added scan %d \n', i);
        end
    end

    figure;
    show(slamAlg);
    title({'Map of the Environment', 'Pose Graph for Initial 10 Scans'});
    ```

3. Continue to add scans and observe the loop closure process:

    ```matlab
    firstTimeLCDetected = false;

    figure;
    for i = 10:length(scans)
        [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(slamAlg, scans{i});
        if ~isScanAccepted
            continue;
        end

        if optimizationInfo.IsPerformed && ~firstTimeLCDetected
            show(slamAlg, 'Poses', 'off');
            hold on;
            show(slamAlg.PoseGraph); 
            hold off;
            firstTimeLCDetected = true;
            drawnow
        end
    end
    title('First loop closure');
    ```

4. Plot the final built map and the robot's trajectory:

    ```matlab
    figure;
    show(slamAlg);
    title({'Final Built Map of the Environment', 'Trajectory of the Robot'});
    ```

### Build Occupancy Grid Map

Generate an occupancy grid map representing the environment as a probabilistic occupancy grid:

```matlab
[scans, optimizedPoses] = scansAndPoses(slamAlg);
map = buildMap(scans, optimizedPoses, mapResolution, maxLidarRange);

figure;
show(map);
hold on;
show(slamAlg.PoseGraph, 'IDs', 'off');
hold off;
title('Occupancy Grid Map Built Using Lidar SLAM');
```

## Features

- Incremental SLAM with pose graph optimization
- Loop closure detection and map correction
- Visualization of the mapping process and trajectory
- Generation of an occupancy grid map

## Configuration

- **Max Lidar Range:** 8 meters (configurable)
- **Map Resolution:** 20 cells per meter (configurable)
- **Loop Closure Threshold:** 210 (configurable)
- **Loop Closure Search Radius:** 8 meters (configurable)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes and commit them.
4. Push your branch to your forked repository.
5. Open a pull request to the main repository.

## License

This project is licensed under the Apache-2.0 License. See the `LICENSE` file for details.

## Contact

For any questions or inquiries, please contact:

- Your Name: [MV.Chirag@iiitb.ac.in](mailto:MV.Chirag@iiitb.ac.in)
- GitHub: [ChiragMV](https://github.com/ChiragMV)

---

## References:
MATLAB
Research papers(present in the repository)

Thank you for using my SLAM with Lidar Scans project! I hope it helps you in your robotics and mapping endeavors.
