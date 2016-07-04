# docker-dataiku-dss

Docker images repository for:

- [Dataiku Science Studio](http://doc.dataiku.com/dss/latest/index.html)
- [Dataiku Automation node](http://doc.dataiku.com/dss/latest/bundles/index.html)
- [Dataiku API node](http://doc.dataiku.com/dss/latest/apinode/index.html) (AKA Scoring node)

All images are built above `dataiku-dss-core` docker image.  
This image is **not** to be ran directly. It's purpose is only to build the other ones.

Docker images are pushed on [https://hub.docker.com/r/jbfavre/](https://hub.docker.com/r/jbfavre/)

## Entrypoint script features

Entrypoint script will:

1. force `/var/lib/dataiku` ownership change at startup
2. determine wether
   * DSS has already been installed
   * a custom license file has been provided [^1]
3. perform
   * initial DSS configuration if file `/var/lib/dataiku/bin/dss` is **not** found inside the container
   * run installer in upgrade mode if file `/var/lib/dataiku/bin/dss` is found inside the container
4. start DSS

## Docker image `dataiku-dss`

Build from `dataiku-dss-core`

Basic setup for [Dataiku Science Studio](http://doc.dataiku.com/dss/latest/index.html).  
To keep docker image small, R is **not** installed.

`dataiku-dss` docker image listens on port `TCP/10000`.  
`dataiku-dss` is available on [https://hub.docker.com/r/jbfavre/dataiku-dss](https://hub.docker.com/r/jbfavre/dataiku-dss)

### Usage

    docker pull jbfavre/dataiku-dss:latest
    docker run -p 10000:10000 -i -v /home/dev/docker-dataiku-dss-data:/var/lib/dataiku -t jbfavre/dataiku-dss:latest

### Build instruction

Clone or fork the repo, then:

    cd dss
    docker build --rm=true -f Dockerfile -t jbfavre/dataiku-dss:latest .

## Docker image `dataiku-anode`

Build from `dataiku-dss-core`

Basic setup for [Dataiku Automation node](http://doc.dataiku.com/dss/latest/bundles/index.html).  
To keep docker image small, R is **not** installed.

`dataiku-anode` docker image listens on port `TCP/11000`.  
`dataiku-dss` is available on [https://hub.docker.com/r/jbfavre/dataiku-dss](https://hub.docker.com/r/jbfavre/dataiku-dss)

### Usage

    docker pull jbfavre/dataiku-anode:latest
    docker run -p 11000:11000 -i -v /home/dev/docker-dataiku-anode-data:/var/lib/dataiku -t jbfavre/dataiku-anode:latest

### Build instruction

Clone or fork the repo, then:

    cd anode
    docker build --rm=true -f Dockerfile -t jbfavre/dataiku-anode:latest .

## Docker image `dataiku-snode`

Build from `dataiku-dss-core`

Basic setup for [Dataiku API node](http://doc.dataiku.com/dss/latest/apinode/index.html) (AKA Scoring node).  
To keep docker image small, R is **not** installed.

`dataiku-snode` docker image listens on port `TCP/12000`.  
`dataiku-snode` is available on [https://hub.docker.com/r/jbfavre/dataiku-snode](https://hub.docker.com/r/jbfavre/dataiku-snode)

### Usage

    docker pull jbfavre/dataiku-snode:latest
    docker run -p 12000:12000 -i -v /home/dev/docker-dataiku-snode-data:/var/lib/dataiku -t jbfavre/dataiku-snode:latest

### Build instruction

Clone or fork the repo, then:

    cd snode
    docker build --rm=true -f Dockerfile -t jbfavre/dataiku-snode:latest .

## Docker image `dataiku-dss-core`

Common setup for Design, Automation & API node.  
This image can't be ran alone.

You should never use it directly.

---

[^1]: entreprise license is **required** for Automation & API nodes.  
  License for Automation node can be added through UI after docker container start  
  License for API node **must** be provided when building image. API node won't start without a valid license
