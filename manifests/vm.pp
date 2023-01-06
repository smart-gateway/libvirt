# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   libvirt::vm { 'namevar': }
define libvirt::vm (
  Integer       $cpus = 1,
  Integer       $memory_mb = 1000,
  Integer       $disk_gb = 10,
  Array[Struct[{
    switch => String,
    port   => String,
    vlan   => Integer,
  }]] $networks = [],
) {

  # Create the domain definition
  $uuid = libvirt::uuid()
  file { "creating ${name} domain definition":
    ensure  => file,
    path    => "/tmp/${name}_domain.xml",
    content => epp('libvirt/vm.epp', {
      'name'      => $name,
      'uuid'      => $uuid,
      'cpus'      => $cpus,
      'memory_mb' => $memory_mb,
      'disk_name' => 'PUT_REAL_DISK_NAME_HERE_AFTER_IT_IS_CREATED.qcow2',
      'networks'  => $networks,
      }),
    replace => no,
  }
}