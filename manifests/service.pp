# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include libvirt::service
class libvirt::service {
  $desired_state = $::libvirt::package_ensure ? {
    'absent'   => false,
    'purged'   => false,
    'disabled' => false,
    default    => true,
  }

  # Setup service state
  service { 'ensure that the ovs service is in the desired state':
    name   => $::libvirt::service_name,
    ensure => $desired_state,
  }
}
