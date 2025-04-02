#
# Create what ever property you want
# Don't use an = sign, just pass the value
# Example: something_new "and it's value"
#
# provision method that accepts a code block that will be executed
#   in the context of the config var, or Vagrant object, passed in
#   the the call ComplyTime.common_provision(config)
#

provision{
  vm.provision "shell", name: "dnf-installs",
    path: "../provision/dnf-installs.sh",
    privileged: false
  
  vm.provision "shell", name: "zsh",
    path: "../provision/zsh.sh",
    privileged: false
  
  vm.provision "shell", name: "python",
    path: "../provision/python.sh",
    privileged: false
}