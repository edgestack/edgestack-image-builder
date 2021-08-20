# Virtual Machine Image Builder for EdgeStack

The Image Builder is a collection of virtual machine image building utilities.
The Image Builder can be used to build golden images intended for use with EdgeStack.

Supported Host OS: 
* CentOS 7

Supported Guest OS:
* CentOS 7
* Ubuntu 18.04
* Ubuntu 20.04

Packer has issues working with qemu-system binary in ubuntu distribution. Make sure that you are using the image builder in CentOS distribution.

### How to use
The project allows the developers to build the image using handy make CLI.

1. Clone Image Builder project
```bash
# git clone https://github.com/sonaproject/edgestack-image-builder.git
# cd edgestack-image-builder
```

2. Install packer and relevant dependencies
```bash
# make deps-qemu
```

3. Build ubuntu-18.04 image
```bash
# make build-qemu-ubuntu-1804
```
The built image will be located under output directory.

4. Clean built images
```bash
# make clean-qemu
```

5. Clean packer cache
```bash
# make clean-packer-cache
```

