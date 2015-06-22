# The Dockerfile for building custom docker registry

FROM golang:1.4

# Install python pip and tools to build awscli
RUN apt-get update && \
    apt-get install -y librados-dev apache2-utils python-dev python-pip && \
    rm -rf /var/lib/apt/lists/*

# install AWS Command Line Interface
RUN pip install awscli
RUN aws configure set default.s3.signature_version s3v4

ENV DISTRIBUTION_DIR /go/src/github.com/docker/distribution
ENV GOPATH $DISTRIBUTION_DIR/Godeps/_workspace:$GOPATH
ENV DOCKER_BUILDTAGS include_rados

WORKDIR $DISTRIBUTION_DIR
COPY . $DISTRIBUTION_DIR
RUN make PREFIX=/go clean binaries

VOLUME ["/var/lib/registry"]
EXPOSE 5000

# run the script which downloads needed files from S3 and runs the registry
ADD run_registry.sh run_registry.sh
RUN chmod +x run_registry.sh
CMD /go/src/github.com/docker/distribution/run_registry.sh

