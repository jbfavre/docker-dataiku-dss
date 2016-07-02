# docker-dataiku-dss

Docker images repository for Dataiku Science Studio, Automation node & Scoring node (AKA API node).  
Docker images are pushed on [https://hub.docker.com/r/jbfavre/](https://hub.docker.com/r/jbfavre/)

## dataiku-dss

Basic setup for Dataiku Science Studio.  
To keep docker image small, R is **not** installed.

`dataiku-dss` docker image listens on port `TCP/10000`.  
`dataiku-dss` is available on [https://hub.docker.com/r/jbfavre/dataiku-dss](https://hub.docker.com/r/jbfavre/dataiku-dss)

### Usage

    docker pull jbfavre/dataiku-dss:latest
    docker run -p 10000:10000 -i -v /home/dev/docker-dataiku-dss-data:/var/lib/dataiku -t jbfavre/dataiku-dss:latest

If Volume `/home/dev/docker-dataiku-dss-data` is empty, entrypoint will perform initial DSS configuration.  
If Volume `/home/dev/docker-dataiku-dss-data` is **not** empty, entrypoint will update DSS configuration.

### Build instruction

Clone or fork the repo, then:

    cd dss
    docker build --rm=true -f Dockerfile -t jbfavre/dataiku-dss:latest .

## dataiku-anode

Basic setup for Dataiku Automation node.
To keep docker image small, R is **not** installed.

`dataiku-anode` docker image listens on port `TCP/11000`.  
`dataiku-dss` is available on [https://hub.docker.com/r/jbfavre/dataiku-dss](https://hub.docker.com/r/jbfavre/dataiku-dss)

### Usage

    docker pull jbfavre/dataiku-anode:latest
    docker run -p 11000:11000 -i -v /home/dev/docker-dataiku-anode-data:/var/lib/dataiku -t jbfavre/dataiku-anode:latest

If Volume `/home/dev/docker-dataiku-anode-data` is empty, entrypoint will perform initial DSS configuration.
If Volume `/home/dev/docker-dataiku-anode-data` is **not** empty, entrypoint will update DSS configuration.

### Build instruction

Clone or fork the repo, then:

    cd anode
    docker build --rm=true -f Dockerfile -t jbfavre/dataiku-anode:latest .

## dataiku-snode

Basic setup for Dataiku Scoring node (AKA API node).
To keep docker image small, R is **not** installed.

`dataiku-snode` docker image listens on port `TCP/12000`.  
`dataiku-snode` is available on [https://hub.docker.com/r/jbfavre/dataiku-snode](https://hub.docker.com/r/jbfavre/dataiku-snode)

### Usage

    docker pull jbfavre/dataiku-snode:latest
    docker run -p 12000:12000 -i -v /home/dev/docker-dataiku-snode-data:/var/lib/dataiku -t jbfavre/dataiku-snode:latest

If Volume `/home/dev/docker-dataiku-snode-data` is empty, entrypoint will perform initial DSS configuration.
If Volume `/home/dev/docker-dataiku-snode-data` is **not** empty, entrypoint will update DSS configuration.

### Build instruction

Clone or fork the repo, then:

    cd snode
    docker build --rm=true -f Dockerfile -t jbfavre/dataiku-snode:latest .
