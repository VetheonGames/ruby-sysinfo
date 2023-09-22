# frozen_string_literal: true

class GpuInfo
  def self.gather_info
    # Initialize an empty hash to store GPU information
    gpu_info = {}

    # Use `lspci` to get basic GPU information
    lspci_output = `lspci | grep VGA`.strip
    if lspci_output && !lspci_output.empty?
      # Extract the model and other details
      model_match = lspci_output.match(/VGA compatible controller: (.+)$/)
      gpu_info[:model] = model_match[1] if model_match
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
