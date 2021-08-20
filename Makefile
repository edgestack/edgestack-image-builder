# Ensure Make is run with bash shell as some syntax below is bash-specific
SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

## --------------------------------------
## Help
## --------------------------------------
##@ Helpers
help: ## Display this help
	@echo NOTE
	@echo '  The "build-qemu-ubuntu" targets have analogue "clean-qemu-ubuntu" targets for'
	@echo '  cleaning artifacts created from building qemu QCOW2 image using a local'
	@echo '  hypervisor.'
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

## --------------------------------------
## Dependencies
## --------------------------------------
##@ Dependencies
.PHONY: deps-qemu
deps-qemu: ## Installs/checks dependencies for QEMU builds
deps-qemu:
	scripts/ensure-packer.sh

# We want the var files passed to Packer to have a specific order, because the
# precenence of the variables they contain depends on the order. Files listed
# later on the CLI have higher precedence. We want the var files that specific 
# to the provider listed first, then any user-supplied var files so that a user 
# can override what they need to.

# A list of variable files given to Packer to configure things like the versions
# of Kubernetes and CNI to install. Any additional files from the
# environment are appended.
COMMON_NODE_VAR_FILES :=	packer/config/golden-image.json \
				packer/config/ansible-args.json

# Initialize a list of flags to pass to Packer. This includes any existing flags
# specified by PACKER_FLAGS, as well as prefixing the list with the variable
# files from COMMON_VAR_FILES, with each file prefixed by -var-file=.
#
# Any existing values from PACKER_FLAGS take precendence over variable files.
PACKER_NODE_FLAGS := $(foreach f,$(abspath $(COMMON_NODE_VAR_FILES)),-var-file="$(f)" ) \
				$(PACKER_FLAGS)
PACKER_VAR_FILES := $(foreach f,$(abspath $(PACKER_VAR_FILES)),-var-file="$(f)" )

## --------------------------------------
## Platform and version combinations
## --------------------------------------
CENTOS_VERSIONS		:=	centos-7
UBUNTU_VERSIONS		:=	ubuntu-1804 ubuntu-2004

PLATFORMS_AND_VERSIONS	:=	$(CENTOS_VERSIONS) \
				$(UBUNTU_VERSIONS)

QEMU_BUILD_NAMES	:=	$(addprefix qemu-,$(PLATFORMS_AND_VERSIONS))

## --------------------------------------
## Dynamic build targets
## --------------------------------------
QEMU_BUILD_TARGETS	:= $(addprefix build-,$(QEMU_BUILD_NAMES))

$(QEMU_BUILD_TARGETS):
	packer build $(PACKER_NODE_FLAGS) -var-file="$(abspath packer/qemu/$(subst build-,,$@).json)" $(PACKER_VAR_FILES) packer/qemu/packer.json
.PHONY: $(QEMU_BUILD_TARGETS)

## --------------------------------------
## Dynamic clean targets
## --------------------------------------
QEMU_CLEAN_TARGETS := $(subst build-,clean-,$(QEMU_BUILD_TARGETS))
.PHONY: $(QEMU_CLEAN_TARGETS)
$(QEMU_CLEAN_TARGETS):
	rm -fr output/$(subst clean-qemu-,,$@).qcow2

## --------------------------------------
## Document dynamic build targets
## --------------------------------------

build-qemu-ubuntu-1804: ## Builds Ubuntu 18.04 QEMU image
build-qemu-ubuntu-2004: ## Builds Ubuntu 20.02 QEMU image
build-qemu-centos-7:    ## Builds CentOS 7 QEMU image

## --------------------------------------
## Clean targets
## --------------------------------------
##@ Cleaning
.PHONY: clean-qemu
clean-qemu: ## Removes all qemu image output directories (see NOTE at top of help)
clean-qemu: $(QEMU_CLEAN_TARGETS)

.PHONY: clean-packer-cache
clean-packer-cache: ## Removes the packer cache
clean-packer-cache:
	rm -fr packer_cache/*
