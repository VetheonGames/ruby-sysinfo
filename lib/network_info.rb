# frozen_string_literal: true

require 'speedtest_net'

class NetworkInfo
  def self.gather_info
    result = SpeedtestNet.run
    {
      download_speed: result.pretty_download,
      upload_speed: result.pretty_upload
    }
  end
end
