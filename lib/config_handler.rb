require 'yaml'
require_relative 'first_run'

class ConfigHandler
  def self.ensure_config_exists(path)
    return unless !File.exist?(path) || !config_valid?(path)

    # Call FirstRun setup to create the config based on user input
    FirstRun.setup(path)
  end

  def self.config_valid?(path)
    # Add your validation logic here. For example, check if all keys exist.
    config = YAML.load(File.read(path))
    # Assuming you have a list of all valid keys
    valid_keys = %w[cpu ram gpu nic_model network_speed os_name kernel_name_version system_uptime disks]
    (valid_keys - config.keys).empty?
  rescue StandardError
    false
  end

  def self.load_config(path)
    YAML.load(File.read(path))
  end
end
