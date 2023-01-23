# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include libvirt::install
class libvirt::install {
  if $::libvirt::package_manage {
    # Ensure packages are in the desired state
    package { "ensure that the qemu-kvm package is ${::libvirt::package_ensure}":
      name   => 'qemu-kvm',
      ensure => $::libvirt::package_ensure,
    }

    package { "ensure that the libvirt-daemon-system package is ${::libvirt::package_ensure}":
      name   => 'libvirt-daemon-system',
      ensure => $::libvirt::package_ensure,
    }

    package { "ensure that the cloud-image-utils package is ${::libvirt::package_ensure}":
      name   => 'cloud-image-utils',
      ensure => $::libvirt::package_ensure,
    }

    package { "ensure that the libguestfs-tools package is ${::libvirt::package_package}":
      name   => 'libguestfs-tools',
      ensure => $::libvirt::package_package,
    }
  }
}
