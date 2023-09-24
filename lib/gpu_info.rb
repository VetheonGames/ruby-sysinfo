# frozen_string_literal: true

class GpuInfo
  def self.gather_info
    # Initialize an empty hash to store GPU information
    gpu_info = {}

    # Use `lspci` to get basic GPU information
    lspci_output = `lspci | grep VGA`.strip

    if lspci_output && !lspci_output.empty?
      # Determine the manufacturer
      manufacturer = case lspci_output
                     when /NVIDIA/
                       'NVIDIA'
                     when /Advanced Micro Devices, Inc./
                       'AMD'
                     when /Intel Corporation/
                       'Intel'
                     else
                       'Unknown'
                     end

      # Extract the model and other details based on manufacturer
      case manufacturer
      when 'NVIDIA'
        model_match = lspci_output.match(/NVIDIA Corporation (\w+) \[.*GTX (\d+ \d+GB)\]/) ||
                      lspci_output.match(/NVIDIA Corporation (\w+) \[.*RTX (\d+ \d+GB)\]/)
        gpu_info[:model] = "NVIDIA GTX #{model_match[2]}" if model_match
      when 'AMD'
        model_match = lspci_output.match(/Advanced Micro Devices, Inc. \[.*Radeon (\w+ \d+)\]/) ||
                      lspci_output.match(/Advanced Micro Devices, Inc. \[.*RX (\d+)\]/)
        gpu_info[:model] = "AMD Radeon #{model_match[1]}" if model_match
      when 'Intel'
        model_match = lspci_output.match(/Intel Corporation.*HD Graphics (\d+)/) ||
                      lspci_output.match(/Intel Corporation.*Iris Xe Graphics/)
        gpu_info[:model] = "Intel #{model_match[1]}" if model_match
      else
        gpu_info[:model] = lspci_output  # Fallback to the original string if no match
      end
    end

    # Fetch Video RAM amount
    vram_output = `lshw -c video | grep size`.strip
    if vram_output && !vram_output.empty?
      vram_match = vram_output.match(/size: (.+)$/)
      gpu_info[:vram] = vram_match[1] if vram_match
    end

    # Fetch OpenGL driver version
    driver_output = `glxinfo | grep "OpenGL version"`.strip
    if driver_output && !driver_output.empty?
      driver_match = driver_output.match(/OpenGL version string: (.+)$/)
      gpu_info[:opengl_driver_version] = driver_match[1] if driver_match
    end

    # Fetch Vulkan driver version
    vulkan_output = `vulkaninfo | grep "Vulkan Instance Version"`.strip
    if vulkan_output && !vulkan_output.empty?
      vulkan_match = vulkan_output.match(/Vulkan Instance Version: (.+)$/)
      gpu_info[:vulkan_driver_version] = vulkan_match[1] if vulkan_match
    end

    # Return the gathered GPU information
    gpu_info
  end
end
