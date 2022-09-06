FROM ghcr.io/greenroom-robotics/ros_builder:latest

# Create the package_manifests by deleting everything other than pyproject.toml, poetry.lock and package.xml
WORKDIR /package_manifests
COPY ./packages .
RUN sudo chown ros:ros .
RUN sudo find . -regextype egrep -not -regex '.*/(pyproject\.toml|poetry\.lock|package\.xml)$' -type f -delete
RUN sudo find . -type d -empty -delete

FROM ghcr.io/greenroom-robotics/ros_builder:latest
LABEL org.opencontainers.image.source=https://github.com/Greenroom-Robotics/maritime_interfaces

ARG API_TOKEN_GITHUB

ENV GHCR_PAT=$API_TOKEN_GITHUB

# Stuff that should be in rosbuilder?
ENV PATH="/home/ros/.local/bin:${PATH}"
RUN pip install pre-commit poetry
RUN poetry config virtualenvs.create false

RUN sudo mkdir /opt/greenroom && sudo chown ros:ros /opt/greenroom

# Configure Greenroom rosdep and debian repos
ENV ROSDISTRO_OVERLAY_INDEX_URL https://raw.githubusercontent.com/Greenroom-Robotics/rosdistro/main/overlay.yaml
RUN curl -s https://$API_TOKEN_GITHUB@raw.githubusercontent.com/Greenroom-Robotics/rosdistro/main/scripts/setup-rosdep.sh | bash -s
RUN curl -s https://$API_TOKEN_GITHUB@raw.githubusercontent.com/Greenroom-Robotics/packages/main/scripts/setup-apt.sh | bash -s

WORKDIR /home

# Install rosdeps
COPY --from=0 /package_manifests ./package_manifests
RUN sudo apt-get update && rosdep update && rosdep install -y -i --from-paths ./package_manifests
RUN find ./package_manifests -type f -name "pyproject.toml" -execdir poetry install \;

WORKDIR /home/ros/maritime_interfaces

# Build
COPY ./ ./
RUN sudo chown -R ros:ros /home/ros/maritime_interfaces
RUN source ${ROS_OVERLAY}/setup.bash && colcon build --merge-install --install-base /opt/greenroom/maritime_interfaces

ENV ROS_OVERLAY /opt/greenroom/maritime_interfaces

CMD tail -f /dev/null