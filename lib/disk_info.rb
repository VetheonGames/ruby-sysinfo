# frozen_string_literal: true

class DiskInfo
  def self.gather_info
    disk_info = []

    # Get additional disk details using `lsblk` command
    lsblk_output = `lsblk -J`.strip
    lsblk_json = JSON.parse(lsblk_output)

    lsblk_json['blockdevices'].each do |device|
      next unless device['type'] == 'disk' # We only want disk devices

      # Skip swap partitions
      next if device['mountpoints']&.include?('[SWAP]')

      # Determine if the disk is SSD or HDD
      rotational_info = File.read("/sys/block/#{device['name']}/queue/rotational").strip
      type = rotational_info == '1' ? 'HDD' : 'SSD'

      # Get transport type using udevadm
      transport = `udevadm info --query=property --name=#{device['name']} | grep ID_BUS | cut -d= -f2`.strip

      # Get disk model from /sys filesystem
      model_path = "/sys/block/#{device['name']}/device/model"
      model = File.exist?(model_path) ? File.read(model_path).strip : 'Unknown'

      disk = {
        model:,
        type:,
        transport: transport || 'Unknown'
      }
      disk_info << disk
      File.open('runtime_log.log', 'a') { |f| f.puts("#{disk}") }
    end

    disk_info
  end
end
