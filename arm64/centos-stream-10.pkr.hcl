locals {
  iso_url       = "https://mirror.shastacoe.net/centos-stream/10-stream/BaseOS/aarch64/iso/CentOS-Stream-10-latest-aarch64-dvd1.iso"
  iso_checksum  = "sha256:cbe3c79baa14f32d175e9293bb21581f0c708f810dd3d41cfd03154980d70b9d"
}

packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "virtualbox-iso" "centos-stream-10" {
  iso_url             = "${local.iso_url}"
  iso_checksum        = "${local.iso_checksum}"
  guest_os_type       = "Oracle9_arm64" # Correct guest OS type for ARM64 VirtualBox
  vm_name             = "centos-stream-10-arm64-vagrant"
  headless            = false # Set to true for headless build if you don't need GUI
  gfx_controller      = "vmsvga"

  http_directory      = "http" # Directory to serve files via HTTP
  http_port_min       = 9000
  http_port_max       = 9010

  boot_command = [
    "<wait><up>e<wait><down><down><end><wait>",
    "linux ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    " inst.text",
    " inst.lang=en_US",
    " inst.keylayout=us",
    "<leftCtrlOn>x<leftCtrlOff><wait>"
  ]
  boot_wait           = "10s"
  shutdown_command    = "sudo /sbin/shutdown -P now"
  shutdown_timeout    = "10m"

  hard_drive_interface= "virtio"
  iso_interface       = "virtio"
  usb                 = true
  disk_size           = "20480" # 20GB disk size
  cpus                = "2"     # Number of CPUs for the VM
  memory              = "2048"  # 2GB RAM for the VM

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--usb-xhci", "on"],
    ["modifyvm", "{{.Name}}", "--usb-ohci", "off"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "qemuramfb"],
  ]

  ssh_username        = "vagrant"
  ssh_password        = "vagrant"
  ssh_port            = 22
  ssh_wait_timeout    = "20m" # Increased SSH wait timeout for ARM64

  output_directory    = "output-centos-stream-10"
}

build {
  sources = ["source.virtualbox-iso.centos-stream-10"]

  post-processors {
    post-processor "vagrant" {
      output = "centos-stream-10.box"
      keep_input_artifact = true # Keep the VM for debugging or further use
      #vagrantfile_template = ["metadata.json"]
    }
  }
}