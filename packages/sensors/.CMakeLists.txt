cmake_minimum_required(VERSION 3.5)

project(maritime_interfaces_sensors)

# Generate messages
find_package(ament_cmake_auto REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(ais_msgs REQUIRED)
find_package(geolocation_msgs REQUIRED)
find_package(hydrographic_msgs REQUIRED)
find_package(environmental_msgs REQUIRED)


ament_auto_find_build_dependencies()

ament_auto_package()
