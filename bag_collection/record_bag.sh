#!/bin/bash

# Define bag file name with timestamp
BAG_NAME="go2_bag_Jan192025"

rm -rf $BAG_NAME

# Topics to record
TOPICS="/tf /tf_static /robot_description /lowstate /sportmodestate /utcamera /camera/d435i/extrinsics/depth_to_accel /camera/d435i/extrinsics/depth_to_color /camera/d435i/extrinsics/depth_to_depth /camera/d435i/extrinsics/depth_to_gyro /camera/d435i/color/camera_info /camera/d435i/color/image_raw /camera/d435i/depth/image_rect_raw /camera/d435i/imu /camera/d435i/depth/camera_info /camera/d435i/color/metadata /camera/d435i/depth/metadata /joint_states /utlidar/imu /utlidar/robot_pose /hesai/pointcloud /hesai/lidar_packets /hesai/lidar_packets_loss /pointcloud /odom"

sleep 1

# Run ros2 bag record command
#ros2 bag record -o $BAG_NAME $TOPICS 

# Run ros2 bag record command (compression)
ros2 bag record $TOPICS --compression-mode file --compression-format zstd
