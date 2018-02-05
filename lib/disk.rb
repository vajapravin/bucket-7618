class Disk
  def initialize connection
    @connection = connection
  end

  def create
    print "Disk name:"
    disk_name = gets.chomp

    print "Disk size in gb:"
    disk_size = gets.chomp.to_i

    print "Disk zone:"
    disk_zone = gets.chomp

    puts "Creating disk..."

    disk = @connection.disks.create(
      name: disk_name,
      size_gb: disk_size,
      zone_name: disk_zone,
      boot: true,
      source_image: 'https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20180126',
      source_image_id: '2108074069701563737'
    )

    disk.wait_for { disk.ready? }

    puts "Disk ready"

    disk
  end
end