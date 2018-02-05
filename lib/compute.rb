require 'fog/google'
require_relative './disk'
require_relative './server'

class Compute
  def initialize
    @connection = Fog::Compute::Google.new(
      google_project: 'pursueon-191807',
      google_client_email: 'pursueon-191807@appspot.gserviceaccount.com',
      google_json_key_location: '~/pursueon-abcb6d92e8db.json'
    )
  end

  def disks
    @disks ||= @connection.disks
  end

  def servers
    @servers ||= @connection.servers
  end

  def generate_server user_input=true
    disk_class = Disk.new(@connection)
    if user_input
      disk = disk_class.create
    else
      disk = disk_class.create("airshaper-disk-#{Time.now.to_i}", 10, "us-east1-b")
    end

    server_class = Server.new(@connection)

    @disks = nil
    @servers = nil

    if user_input
      server_class.create(disk)
    else
      server_class.create(disk, "airshaper-server-#{Time.now.to_i}", "airshaper")
    end
  end
end