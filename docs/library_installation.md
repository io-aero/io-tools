# IO-TEMPLATE - Library - Installation

## 1. Use as a library

TODO

## 2. Use of a Docker container

TODO

A fully functional Docker image is available [here](https://hub.docker.com/repository/docker/io-aero/io_template){:target="_blank"} on DockerHub. 
From this, a local Docker container can be created with the following command:

    docker run -it --name io_template -v <local directory>:/io_template/data/inbox_prod io-aero/io_template:0.9.1

`<local directory>` is the local directory where the files created during the processing are stored.
In addition to the software listed under prerequisites, the Docker container also contains a complete virtual environment for running **IO-TEMPLATE** in suitable versions.