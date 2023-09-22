# frozen_string_literal: true

require 'English'

require 'json'

class NicInfo
  def self.gather_info
    raw_data = `lshw -class network -json 2>&1`
    unless $CHILD_STATUS.success?
      return [{ model: 'No permission', manufacturer: 'No permission',
                max_speed: 'No permission' }]
    end

    parsed_data = JSON.parse(raw_data)
    nic_info = []

    parsed_data.each do |data|
      info = {}
      info[:model] = data['product']
      info[:manufacturer] = data['vendor']

      # Extracting max speed if available
      info[:max_speed] = data['capabilities']['speed'] if data['capabilities'] && data['capabilities']['speed']

      nic_info << info
    end

    File.open('./runtime_log.log', 'w') { |f| f.puts(nic_info.to_json) }
    nic_info
  rescue JSON::ParserError
    [{ model: 'No permission', manufacturer: 'No permission', max_speed: 'No permission' }]
  end
end
