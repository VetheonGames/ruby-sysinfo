require 'json'

class DiskInfo
  def self.gather_info
    disk_info = []

    # Get additional disk details using `lsblk` command
    lsblk_output = `lsblk -J`.strip
    lsblk_json = JSON.parse(lsblk_output)
    lsblk_json['blockdevices'].each do |device|
      next unless device['type'] == 'disk'  # We only want disk devices

      disk = {
        model: device['model'],
        type: device['rota'] == '1' ? 'HDD' : 'SSD',
        transport: device['tran']
      }
      disk_info << disk
    end

    disk_info
  end
end
