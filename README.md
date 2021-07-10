# Pi-UPS Prometheus Exporter

## Introduction

52pi offer a range of boards that can be loaded with two 18650 cells to provide battery-backed UPS functionality for your Raspberry Pi.

The 52pi wiki pages provide sample Python scripts for reading power consumption and other metrics (depending on the model) from the board via I2C.

This project adapts those sample scripts and uses Rico Berger's script_exporter package to create a Prometheus exporter for the 52pi UPS board power metrics.

## Build script_exporter Base Image

This piups_exporter project is built on Rico Bergers script_exporter project.  There is a base image for script_exporter on Docker Hub but it only supports amd64 architecture so we need to rebuild it for armv7 so we can use it on our Raspberry Pi.

Fortunately Rico has included the Dockerfile in his project, so assuming you already have Docker on your Pi, it's very easy to build the armv7 Docker image for script_exporter as follows:

```bash
git clone https://github.com/ricoberger/script_exporter.git
cd script_exporter
sudo docker build -t ricoberger/script_exporter:latest .
```

Depending on how you manage images, you may want to tag this differently and you may want to push it to a private repository, but these steps are optional.

## Build piups_exporter Image

Now that you have the base image built on your Raspberry Pi, we can build the piups_exporter as follows:

```bash
git clone TODO
cd piups_exporter
./build.sh
```

## Test piups_exporter

Run the exporter in interactive mode using the supplied convenience script:

```bash
./run.sh
```

In a different shell window or from another host, `curl` the UPS metrics:

```bash
curl http://localhost:9469/probe?script=piups
```

Note that the script_exporter exposes script-derived metrics using the /probe endpoint and publishes it's own gostats on /metrics.  See the script_exporter documentation for further elaboration on how this works.

## Production Deployment on Docker Swarm

piups_exporter can be run in Docker Compose using the supplied docker-compose.yaml:

```yaml
version: "3"
services:

  piups_exporter:
    devices:
      - "/dev/i2c-1:/dev/i2c-1"
    image: "brendonmatheson/piups_exporter:latest"
    ports:
      - "9469:9469"
    restart: "always"
```

Importantly we need to map the i2c bus into the container so that it is available to the Python script that will be pulling metrics from the board.

Then you can launch the service with the supplied convenience script:

```bash
./start.sh
```

which actually just does:

```bash
sudo docker-compose up
```

To stop the service use the supplied conveience script:

```bash
sudo docker-compose down
```

which actually just does:

```bash
sudo docker-compose down
```

## Prometheus Scrape Job

Now add a job to your Prometheus server's config.  The only thing you have to change is the target:

```yaml
  - job_name: "piups"
    metrics_path: "/probe"
	params:
      script: ["piups"]
    static_configs:
      - targets:
          - "10.80.3.31:9469"
    scrape_interval: 10s
```

