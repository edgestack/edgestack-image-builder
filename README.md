# Virtual Machine Image Builder for EdgeStack

The Image Builder is a collection of virtual machine image building utilities.
The Image Builder can be used to build golden images intended for use with EdgeStack.

Supported Host OS: 
* CentOS 7

Supported Guest OS:
* CentOS 7
* Rocky 8
* Ubuntu 16.04
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

3. Place the base or preprossed golden VM image under images directory
```bash
# cp $IMAGE_NAME images/
```

4. Calculate the checksum of the target VM image
```bash
# sha256sum images/$IMAGE_NAME
```

5. Copy and paste the calculated checksum to the corresponding configuration file. We provide the configuration file for each linux distro. Put the checksum value into ```iso_checksum``` to replace the original value.
```json
{
  "build_name": "ubuntu-1804",
  "distro_name": "ubuntu",
  "ssh_username": "ubuntu",
  "os_display_name": "Ubuntu 18.04",
  "guest_os_type": "ubuntu-64",
  "iso_url": "images/ubuntu-1804.qcow2",
  "iso_checksum": "50c38d3f7307fe770c15a69b316d0001ac28e484239218d23e1ca8c8e7ec9a10",
  "iso_checksum_type": "sha256",
  "shutdown_command": "shutdown -P now",
  "ansible_python_interpreter": "/usr/bin/python3"
}
```

6. Build ubuntu-18.04 golden image
```bash
# make build-qemu-ubuntu-1804
```
The built image will be located under output directory.

7. Clean built images
```bash
# make clean-qemu
```

8. Clean packer cache
```bash
# make clean-packer-cache
```

