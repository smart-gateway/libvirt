# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include libvirt
class libvirt(
  Boolean       $package_manage = true,
  String        $package_ensure = 'present',
  Array[String] $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
  Array[String] $users = [],
) {
  # Ensure class declares subordinate classes
  contain libvirt::install
  contain libvirt::config
  contain libvirt::service

  # Ensure execution ordering
  anchor { '::libvirt::begin': }
  -> Class['::libvirt::install']
  -> Class['::libvirt::config']
  -> Class['::libvirt::service']
  -> anchor { '::libvirt::end': }
}
