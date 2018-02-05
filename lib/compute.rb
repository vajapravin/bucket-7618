require 'fog/google'
require_relative './disk'
require_relative './server'

class Compute
  def initialize
    @connection = Fog::Compute::Google.new(
      google_project: 'pursueon-191807',
      google_client_email: 'pursueon-191807@appspot.gserviceaccount.com',
      google_json_key_location: '/Users/pravinvaja/ruby_workspace/airshaper/pursueon-abcb6d92e8db.json'
    )
  end

  def disks
    @disks ||= @connection.disks
  end

  def servers
    @servers ||= @connection.servers
  end

  def generate_server
    disk_class = Disk.new(@connection)
    disk = disk_class.create

    server_class = Server.new(@connection)

    @disks = nil
    @servers = nil

    server_class.create(disk)
  end
end