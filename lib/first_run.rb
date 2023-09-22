require 'yaml'
require 'tty-prompt'

class FirstRun
  def self.setup(config_path)
    prompt = TTY::Prompt.new
    puts "Welcome to SystemInfo! Let's set up your configuration."

    config = {
      'cpu' => prompt.yes?('Do you want to display CPU information, including Cores, Threads, Model, Clock Speed,
                            and L3 cache?'),
      'ram' => prompt.yes?('Do you want to display RAM amount, usage at idle, and usage under load?'),
      'gpu' => prompt.yes?('Do you want to display GPU Model, Video RAM amount, and driver version?'),
      'nic_model' => prompt.yes?('Do you want to display NIC Model number, manufacturer, and max speed?'),
      'network_speed' => prompt.yes?('Do you want to display current network upload and download speed?'),
      'os_name' => prompt.yes?('Do you want to display the Operating System name?'),
      'kernel_name_version' => prompt.yes?('Do you want to display the Kernel version?'),
      'system_uptime' => prompt.yes?('Do you want to display how long the system has been on without restarting?'),
      'disks' => prompt.yes?('Do you want to display disk information?'),
      'display_resolution' => prompt.yes?('Do you want to display the current display resolution of each monitor?'),
      'theme' => prompt.yes?('Do you want to display the current theme the system is using, if any?'),
      'desktop_environment' => prompt.yes?('Do you want to display the current desktop environment the system
                                            is using?'),
      'window_manager' => prompt.yes?('Do you want to display the current window manager the system is using?'),
      'terminal' => prompt.yes?('Do you want to display the current terminal emulator that the system is using?'),
      'shell' => prompt.yes?('Do you want to display the current shell the terminal is using?'),
      'hostname' => prompt.yes?('Do you want to display the current host name of the system?'),
      'board_model' => prompt.yes?('Do you want to display the system\'s motherboard model name from DMIDecode?'),
      'chipset' => prompt.yes?('Do you want to display the current chipset the system is using from DMIDecode?'),
      'amount_of_monitors' => prompt.yes?('Do you want to display the amount of monitors the system currently is
                                           using?'),
      'sound_drivers' => prompt.yes?('Do you want to display which sound driver the system is using right now?'),
      'sound_card' => prompt.yes?('Do you want to display the current sound card that the system is using?'),
      'display_technology' => prompt.yes?('Do you want to display what display tech the monitors are using?'),
      'color_bit_depth' => prompt.yes?('Do you want to display the color bit depth of the monitors the system is
                                        using?'),
      'package_managers' => prompt.yes?('Do you want to display the package manager or managers that the system is using
                                         and how many packages are installed from each?'),
      'file_systems' => prompt.yes?('Do you want to display which file systems the drives are using?')
    }

    File.puts(config_path, config.to_yaml)
    puts 'Configuration saved!'
  end
end
