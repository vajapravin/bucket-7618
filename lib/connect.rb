require 'rubygems'
require 'active_support/all'
require 'terminal-table'
require_relative './compute'
require 'pry'

class Connect
  def initialize
    @filter_keys = %i(id name status zone)
    @compute = Compute.new
  end

  def instance_process user_input=true
    server_list
    server_name = @compute.generate_server(user_input)
    server_list
    server_name
  end

  private

  def filter_values disk
    attributes = disk.attributes.select{|k,v| @filter_keys.include?(k)}
    attributes[:zone] = slice_zone(attributes[:zone])
    attributes.values
  end

  def slice_zone zone
    zone.split('/').last
  end

  def server_list
    rows = []
    unless @compute.servers.size.eql?(0)
      @compute.servers.each do |server|
        rows << filter_values(server)
      end
    end
    formatted_results(rows)
  end

  def formatted_results rows
    table = Terminal::Table.new headings: @filter_keys.map(&:to_s).map(&:humanize), rows: rows
    puts table
  end
end

connect = Connect.new
if ARGV.blank?
  server_name = connect.instance_process(false)
  `gcloud compute scp --zone us-east1-b ~/airshaper/input/sample.txt #{server_name}:~/sample.txt`
  `gcloud compute ssh --zone us-east1-b #{server_name} --command 'cat /proc/cpuinfo >> ~/output.txt; lsb_release -a >> ~/output.txt'`
  `gcloud compute scp --zone us-east1-b #{server_name}:~/output.txt ~/output-#{server_name}.txt`
else
  connect.instance_process(false)
end
