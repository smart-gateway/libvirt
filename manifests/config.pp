# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include libvirt::config
class libvirt::config {
 if $::libvirt::package_manage {
   # Add any specified users to the libvirt group
   $::libvirt::users.each | Integer $idx, String $user | {
     exec { "add user ${user} to libvirt group":
       command => "adduser $user libvirt",
       path    => $::libvirt::path,
       unless  => "getent group libvirt | grep -q '\\b${user}\\b'",
     }
   }
 }
}
