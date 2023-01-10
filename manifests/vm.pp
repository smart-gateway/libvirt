# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   libvirt::vm { 'namevar': }
define libvirt::vm (
  Boolean       $autostart = true,
  Integer       $cpus = 1,
  Integer       $memory_mb = 1000,
  Integer       $disk_gb = 10,
  String        $disk_directory = '/var/lib/libvirt/images',
  Boolean       $disk_preallocate = true,
  Array[Struct[{
    switch => String,
    port   => String,
    vlan   => Integer,
  }]]           $networks = [],
) {

  # Create the disk
  $cmd_basic = "qemu-img create -f qcow2 ${disk_directory}/${name}.qcow2 ${disk_gb}G"
  if $disk_preallocate {
    $cmd = "${cmd_basic} -o preallocation=full"
  } else {
    $cmd = $cmd_basic
  }
  exec { "create the virtual disk ${disk_directory}/${name}.qcow2":
    command => $cmd,
    path    => $::libvirt::path,
    unless  => "test -f ${disk_directory}/${name}.qcow2",
  }

  # Create the domain definition
  # TODO: have to set replace = no; otherwise it will replace every run since a new uuid will be generated. This makes
  # TODO: it slightly more tricky when there are legit changes to the VM. Need to come up with a clean solution still.
  $uuid = libvirt::uuid()
  file { "creating ${name} domain definition":
    ensure  => file,
    path    => "/tmp/${name}_domain.xml",
    content => epp('libvirt/vm.epp', {
      'name'      => $name,
      'uuid'      => $uuid,
      'cpus'      => $cpus,
      'memory_mb' => $memory_mb,
      'disk_name' => "${disk_directory}/${name}.qcow2",
      'networks'  => $networks,
      }),
    replace => no,
  }

  # Create the virtual machine
  exec { "create ${name} virtual machine":
    command => "virsh define /tmp/${name}_domain.xml",
    path    => $::libvirt::path,
    unless  => "virsh dominfo ${name}",
    notify  => Exec["start ${name} virtual machine"],
  }

  # Start the virtual machine
  exec { "start ${name} virtual machine":
    command     => "virsh start ${name}",
    path        => $::libvirt::path,
    unless      => "virsh list --state-running | grep -q '\b${name}\b'",
    refreshonly => true,
  }

  if $autostart {
    # Set autostart
    exec { "configure ${name} for auto-start":
      command => "virsh autostart ${name}",
      path    => $::libvirt::path,
      unless  => "virsh dominfo ${name} | grep 'Autostart:' | awk '{print $2}' | grep -q 'enable'",
    }
  }

}