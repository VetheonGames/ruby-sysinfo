# frozen_string_literal: true

class CpuInfo
  def self.gather_info
    cpu_info = {}
    cores = 0
    threads = 0

    File.open('/proc/cpuinfo', 'r') do |f|
      f.each_line do |line|
        key, value = line.split(':')
        next unless key && value

        key = key.strip
        value = value.strip

        # Count the number of cores and threads
        cores += 1 if key == 'core id'
        threads += 1 if key == 'processor'

        # Filter out the specific information
        case key
        when 'model name'
          cpu_info[:model] = value
        when 'cpu MHz'
          speed_ghz = (value.to_f * 1e-3).round(2)
          cpu_info[:speed] = "#{speed_ghz} GHz"
        when 'cache size'
          cpu_info[:l3_cache] = value if value.include?('L3')
        end
      end
    end

    cpu_info[:cores] = cores
    cpu_info[:threads] = threads
    cpu_info
  end
end
