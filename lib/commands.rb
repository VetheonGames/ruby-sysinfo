require_relative 'cpu_info'
require_relative 'ram_info'
require_relative 'disk_info'
require_relative 'gpu_info'
require_relative 'kernel_info'
require_relative 'network_info'
require_relative 'nic_info'
require_relative 'os_info'
require_relative 'uptime_info'
require_relative 'display_handler'  # Add this line to require the DisplayHandler class
require_relative 'config_handler'   # Add this line to require the ConfigHandler class

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
    File.open('runtime_log.log', 'w') { |f| f.puts('Starting system info gathering... \n') }
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering CPU info \n') }
    system_info[:cpu] = CpuInfo.gather_info if config['cpu']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering RAM info \n') }
    system_info[:ram] = RamInfo.gather_info if config['ram']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering Disk info \n') }
    system_info[:disks] = DiskInfo.gather_info if config['disks']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering GPU info \n') }
    system_info[:gpu] = GpuInfo.gather_info if config['gpu']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering Kernel info \n') }
    system_info[:kernel] = KernelInfo.gather_info if config['kernel']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering Network info \n') }
    system_info[:network] = NetworkInfo.gather_info if config['network']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering NIC info \n') }
    system_info[:nic] = NicInfo.gather_info if config['nic']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering OS info \n') }
    system_info[:os] = OsInfo.gather_info if config['os']
    File.open('runtime_log.log', 'a') { |f| f.puts('Gathering Uptime info \n') }
    system_info[:uptime] = UptimeInfo.gather_info if config['uptime']

    # Pass the collected data to a display handler
    DisplayHandler.display(system_info)
  end
end
