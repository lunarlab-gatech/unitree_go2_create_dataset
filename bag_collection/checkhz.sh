#!/bin/bash

# Check if ROS2 is sourced
if ! command -v ros2 &> /dev/null; then
    echo "ROS2 is not sourced or installed. Please source the ROS2 setup.bash script."
    exit 1
fi

# Check if a bag file directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <rosbag_directory>"
    exit 1
fi

BAG_DIR="$1"

# Get rosbag info
BAG_INFO=$(ros2 bag info "$BAG_DIR" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "Failed to retrieve bag info. Please check the bag directory."
    exit 1
fi

# Extract total duration
DURATION=$(ros2 bag info "$BAG_DIR" | awk '/Duration:/ {print $2}' | tr -d 's')

if [ -z "$DURATION" ]; then
    echo "Error: Could not extract duration from rosbag info."
    exit 1
fi

topics=$(ros2 bag info "$BAG_DIR" | grep -oE 'Topic: [^|]+' | sed -E 's/Topic: //')
counts=$(ros2 bag info "$BAG_DIR" | grep -oE 'Count: [0-9]+' | awk '{print $2}')

echo "----------------------------------------------------------------------------------------"
echo "Calculating topic frequencies (Hz)..."
echo "----------------------------------------------------------------------------------------"

index=0
output=""
while read -r topic; do
    count=$(echo "$counts" | sed -n "$((index + 1))p")
    frequency=$(LC_NUMERIC="C" awk -v count="$count" -v duration="$DURATION" 'BEGIN {printf "%.2f", count / duration}')
    output+="${topic} ${frequency}\n"
    index=$((index + 1))
done <<< "$topics"

# Remove any leading/trailing newlines and sort alphabetically by topic
echo -e "$output" | grep -v '^$' | sort | awk '{printf "Topic: %-50s Frequency: %.2f Hz\n", $1, $2}'

# Display the total number of topics
num_topics=$(echo "$topics" | wc -l)
echo "----------------------------------------------------------------------------------------"
echo "Total Duration: ${DURATION} seconds"
echo "Total number of topics: $num_topics"
echo "----------------------------------------------------------------------------------------"
