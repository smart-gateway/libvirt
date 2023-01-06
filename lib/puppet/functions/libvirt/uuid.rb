require 'securerandom'

Puppet::Functions.create_function(:'libvirt::uuid') do
  def uuid()
    # Return a uuid
    return SecureRandom.uuid
  end
end