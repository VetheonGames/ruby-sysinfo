# frozen_string_literal: true

class OsInfo
  def self.gather_info
    os_info = {}

    # Get OS Name
    os_info[:os_name] = begin
      `lsb_release -d`.split(':').last.strip
    rescue StandardError
      'Unknown'
    end

    # Get Desktop Environment
    env = ENV['XDG_CURRENT_DESKTOP'] || ENV['DESKTOP_SESSION'] || 'Unknown'
    os_info[:desktop_environment] = env

    # Get Window Manager
    wm = begin
      `wmctrl -m`.match(/Name: (.+)/).captures.first
    rescue StandardError
      'Unknown'
    end
    os_info[:window_manager] = wm

    # Get Sound Driver
    sound_driver = begin
      `pactl info`.match(/Server String: (.+)/).captures.first.split('.').first
    rescue StandardError
      'Unknown'
    end
    os_info[:sound_driver] = sound_driver

    os_info
  end
end
