# Ensure that 'all' is the default target otherwise it will be the first target from Makefile.common.
all::

export CGO_ENABLE := 1
export GOEXPERIMENT := boringcrypto
# Needs to be defined before including Makefile.common to auto-generate targets
DOCKER_ARCHS ?= amd64 armv7 arm64 ppc64le
DOCKER_REPO  ?= prometheuscommunity

include Makefile.common

DOCKER_IMAGE_NAME       ?= postgres-exporter
