# frozen_string_literal: true

require 'tty-prompt'
require 'json'

class DisplayHandler
  def self.display(system_info)
    # Log the entire system_info to a log file
    File.open('system_info.log', 'w') do |f|
      f.puts(JSON.pretty_generate(system_info))
    end

    prompt = TTY::Prompt.new

    choices = [
      { name: 'OS Info', value: :os },
      { name: 'Hardware Info', value: :hardware },
      { name: 'Network Info', value: :network },
      { name: 'Exit', value: :exit }
    ]

    loop do
      user_choice = prompt.select('Choose an option:', choices)

      case user_choice
      when :os
        display_os_info(system_info.slice(:kernel, :os, :uptime))
      when :hardware
        display_hardware_info(system_info.slice(:cpu, :ram, :disk, :gpu))
      when :network
        display_network_info(system_info.slice(:network, :nic))
      when :exit
        break
      end
    end
  end

  def self.display_os_info(os_info)
    # Display OS information
    puts "\nOS Information:"
    puts '---------------'
    os_info.each do |key, value|
      puts "#{key.capitalize}: #{value}"
    end
  end

  def self.display_hardware_info(hardware_info)
    # Display Hardware information (CPU, RAM, etc.)
    puts "\nHardware Information:"
    puts '---------------------'
    hardware_info.each do |key, value|
      puts "#{key.capitalize}: #{value}"
    end
  end

  def self.display_network_info(network_info)
    # Display Network information
    puts "\nNetwork Information:"
    puts '--------------------'
    network_info.each do |key, value|
      puts "#{key.capitalize}: #{value}"
    end
  end
end
