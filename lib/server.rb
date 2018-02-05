class Server
  COMPUTE_ZONE = 'us-east1-b'
  MACHINE_TYPE = 'f1-micro'

  def initialize connection
    @connection = connection
  end

  def create disk, server_name=nil, user_name=nil
    if server_name.nil?
      print "Server name:"
      server_name = gets.chomp
    end

    if user_name.nil?
      print "User name:"
      user_name = gets.chomp
    end

    puts "Creating server..."

    server = @connection.servers.create(
      name: server_name,
      disks: [disk],
      machine_type: MACHINE_TYPE,
      private_key_path: File.expand_path("~/.ssh/id_rsa"),
      public_key_path: File.expand_path("~/.ssh/id_rsa.pub"),
      zone: COMPUTE_ZONE,
      username: user_name,
      network_interfaces: [{access_configs:[{kind:"compute#accessConfig", name:"External NAT", type:"ONE_TO_ONE_NAT"}]}],
      tags: {items: ["http-server"]},
      scheduling: {automatic_restart: true, on_host_maintenance: "MIGRATE", preemptible: false},
      image: 'ubuntu-1604-xenial-v20180126'
    )

    server.wait_for { server.ready? }

    puts "Server ready"

    server.name
  end
end