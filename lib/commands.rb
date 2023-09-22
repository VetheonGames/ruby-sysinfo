require_relative 'cpu_info'
require_relative 'ram_info'
require_relative 'disk_info'
require_relative 'gpu_info'
require_relative 'kernel_info'
require_relative 'network_info'
require_relative 'nic_info'
require_relative 'os_info'
require_relative 'uptime_info'
require_relative 'config_handler'  # Add this line to require the ConfigHandler class
# ... other requires

module Commands
  def self.handle(args, config)
    if args.include?('--clean') || args.include?('-c')
      # Remove the existing config file
      config_path = './config/systeminfo_config.yml'
      File.delete(config_path) if File.exist?(config_path)

      # Print message and exit
      puts 'Configuration file has been removed. Please re-run the system to generate a new configuration.'
      exit
    end

    return unless args.empty?

    system_info = {}

    # Run the system info display
    system_info[:cpu] = CpuInfo.new.gather_info if config['cpu']
    system_info[:ram] = RamInfo.new.gather_info if config['ram']
    # ... other info gathering

    # Pass the collected data to a display handler
    DisplayHandler.display(system_info)
  end
end
