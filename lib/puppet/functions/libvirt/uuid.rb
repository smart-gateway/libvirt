Puppet::Functions.create_function(:'libvirt::uuid') do
  def uuid()
    # Return a uuid
    return 'this_is_not_a_real_uuid'
  end
end