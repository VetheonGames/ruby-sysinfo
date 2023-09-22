# frozen_string_literal: true

require 'English'
class RamInfo
  def self.gather_info
    ram_info = {}

    # Get total and used RAM in GB
    mem_data = `free -g`.split("\n")[1].split(/\s+/)
    ram_info[:total_ram] = mem_data[1].to_i
    ram_info[:used_ram] = mem_data[2].to_i

    # Get RAM type and speed
    begin
      dmi_data = `sudo dmidecode --type 17`.split("\n")
      ram_info[:ram_type] = dmi_data.select { |line| line =~ /Type:/ }.first.split(':').last.strip
      ram_info[:ram_speed] = dmi_data.select { |line| line =~ /Speed:/ }.first.split(':').last.strip
    rescue StandardError
      ram_info[:ram_type] = 'No permission'
      ram_info[:ram_speed] = 'No permission'
    end

    # Handle permission issues
    if $CHILD_STATUS.exitstatus != 0
      ram_info[:ram_type] = 'No permission'
      ram_info[:ram_speed] = 'No permission'
    end

    ram_info
  end
end
