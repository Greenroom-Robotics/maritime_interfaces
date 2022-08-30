# All rights reserved.
cmake_minimum_required(VERSION 3.5)

### Export std_msgs/Headers
project(maritime_interfaces_sensors)

# Generate messages
find_package(ament_cmake_auto REQUIRED)
find_package(std_msgs REQUIRED)
find_package(sensor_msgs REQUIRED)

ament_auto_find_build_dependencies()

set(GENERIC_INTERFACES
  generic/Pressure.msg
  generic/Temperature.msg
)

set(BATTERY_INTERFACES
  battery/Battery.msg
)

set(HYDROGRAPHIC_MSGS

  hydrographic_msgs/acoustic_msgs/msg/DetectionFlag.msg
  hydrographic_msgs/acoustic_msgs/msg/Dvl.msg
  hydrographic_msgs/acoustic_msgs/msg/PingInfo.msg
  hydrographic_msgs/acoustic_msgs/msg/ProjectedSonarImage.msg
  hydrographic_msgs/acoustic_msgs/msg/RawSonarImage.msg
  hydrographic_msgs/acoustic_msgs/msg/SonarDetections.msg
  hydrographic_msgs/acoustic_msgs/msg/SonarImageData.msg
  hydrographic_msgs/acoustic_msgs/msg/SonarRanges.msg
  hydrographic_msgs/environmental_msgs/msg/TurbidityNTU.msg
)

rosidl_generate_interfaces(${PROJECT_NAME}
    ${GENERIC_INTERFACES}
    ${BATTERY_INTERFACES}
    ${HYDROGRAPHIC_MSGS}

  DEPENDENCIES
    "std_msgs"
    "sensor_msgs"
  ADD_LINTER_TESTS
)

if(BUILD_TESTING)

endif()

ament_auto_package()

