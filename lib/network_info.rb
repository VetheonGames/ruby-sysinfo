# frozen_string_literal: true

require 'speedtest_net'

class NetworkInfo
  def self.gather_info
    result = SpeedtestNet.run
    network_info = {
      download_speed: result.pretty_download,
      upload_speed: result.pretty_upload
    }

    File.open('./runtime_log.log', 'w') { |f| f.puts(network_info.to_json) }
    network_info
  end
end
