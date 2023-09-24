# frozen_string_literal: true

class CpuInfo
  def self.gather_info
    cpu_info = {}
    cores = 0
    threads = 0
    manufacturer = nil

    File.open('/proc/cpuinfo', 'r') do |f|
      f.each_line do |line|
        key, value = line.split(':')
        next unless key && value

        key = key.strip
        value = value.strip

        # Count the number of cores and threads
        cores += 1 if key == 'core id'
        threads += 1 if key == 'processor'

        # Determine the manufacturer
        if key == 'vendor_id'
          manufacturer = if value.include?('Intel')
                           'Intel'
                         elsif value.include?('AMD')
                           'AMD'
                         else
                           'Unknown'
                         end
        end

        # Filter out the specific information based on manufacturer
        case key
        when 'model name'
          case manufacturer
          when 'Intel'
            cleaned_model = value.match(/Intel\(R\) Core\(TM\) (\w+-?\d+)/)
            cpu_info[:model] = "Intel Core #{cleaned_model[1]}" if cleaned_model
          when 'AMD'
            cleaned_model = value.match(/AMD Ryzen (\d+ \w+)/)
            cpu_info[:model] = "AMD Ryzen #{cleaned_model[1]}" if cleaned_model
          end
        when 'cpu MHz'
          speed_ghz = (value.to_f * 1e-3).round(2)
          cpu_info[:speed] = "#{speed_ghz} GHz"
        end
      end
    end

    # Fetch L3 Cache size using lscpu
    lscpu_output = `lscpu | grep "L3 cache"`.strip
    if lscpu_output && !lscpu_output.empty?
      l3_cache_match = lscpu_output.match(/L3 cache:\s+(.+)/)
      cpu_info[:l3_cache] = l3_cache_match[1] if l3_cache_match
    end

    cpu_info[:cores] = cores
    cpu_info[:threads] = threads
    cpu_info
  end
end
