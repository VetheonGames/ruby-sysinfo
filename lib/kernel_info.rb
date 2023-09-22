# frozen_string_literal: true

class KernelInfo
  def self.gather_info
    # Initialize an empty hash to store kernel information
    kernel_info = {}

    # Use `uname` to get the kernel version
    uname_output = `uname -r`.strip
    kernel_info[:version] = uname_output if uname_output && !uname_output.empty?

    # Return the gathered kernel information
    File.open('kernel_info.log', 'w') { |f| f.puts(kernel_info.to_json) }
    kernel_info
  end
end
