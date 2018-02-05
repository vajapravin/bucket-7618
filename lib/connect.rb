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

  def instance_process
    server_list
    server_name = @compute.generate_server
    server_list
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
connect.instance_process