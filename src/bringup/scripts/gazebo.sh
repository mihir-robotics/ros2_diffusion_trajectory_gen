#!/bin/bash
# Single script to launch the myCobot with Gazebo and ROS 2 Controllers

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"

if [ -f /opt/ros/jazzy/setup.bash ]; then
    # shellcheck source=/dev/null
    source /opt/ros/jazzy/setup.bash
fi
if [ -f "${WS_ROOT}/install/setup.bash" ]; then
    # shellcheck source=/dev/null
    source "${WS_ROOT}/install/setup.bash"
else
    echo "Workspace not built: missing ${WS_ROOT}/install/setup.bash"
    echo "Run: cd ${WS_ROOT} && colcon build && source install/setup.bash"
    exit 1
fi

cleanup() {
    echo "Cleaning up..."
    sleep 5.0
    pkill -9 -f "ros2|gazebo|gz|nav2|amcl|bt_navigator|nav_to_pose|rviz2|assisted_teleop|cmd_vel_relay|robot_state_publisher|joint_state_publisher|move_to_free|mqtt|autodock|cliff_detection|moveit|move_group|basic_navigator"
}
 
# Set up cleanup trap
trap 'cleanup' SIGINT SIGTERM
 
echo "Launching Gazebo simulation..."
ros2 launch gazebo gazebo.launch.py \
    load_controllers:=true \
    world_file:=pick_and_place_demo.world \
    use_rviz:=true \
    use_robot_state_pub:=true \
    use_sim_time:=true \
    x:=0.0 \
    y:=0.0 \
    z:=0.05 \
    roll:=0.0 \
    pitch:=0.0 \
    yaw:=0.0