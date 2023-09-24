# frozen_string_literal: true

require 'curses'
require 'readline'

class DisplayHandler
  def self.display(system_info)
    setup_readline
    Curses.init_screen
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_BLUE, Curses::COLOR_BLACK)
    Curses.init_pair(2, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses.init_pair(3, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)

    @main_win = Curses::Window.new(0, 0, 0, 0)
    @menu_win = @main_win.subwin(Curses.lines - 4, 20, 1, 1)
    @info_win = @main_win.subwin(Curses.lines - 4, Curses.cols - 22, 1, 22)
    @menu_win.keypad(true)

    exit_menu = false # Flag to indicate if the menu should exit

    loop do
      draw_main_box
      draw_menu_box
      draw_info_box

      choices = ['OS Info', 'Hardware Info', 'Network Info', 'Exit']
      selected_index = 0

      loop do
        row = 2  # Starting row
        col = 3  # Starting column
        choices.each_with_index do |choice, index|
          @menu_win.setpos(row + index, col) # Explicitly set position for each choice
          if index == selected_index
            @menu_win.attron(Curses.color_pair(3)) { @menu_win.addstr(choice) }
          else
            @menu_win.addstr(choice)
          end
          @menu_win.setpos(row + index + 1, col) # Move to the next line
        end
        @menu_win.refresh

        input = @menu_win.getch
        case input
        when Curses::KEY_UP
          selected_index = [selected_index - 1, 0].max
        when Curses::KEY_DOWN
          selected_index = [selected_index + 1, choices.length - 1].min
        when 10, 13 # Enter key
          case choices[selected_index]
          when 'Exit'
            exit_menu = true # Set flag to true
            break # Break inner loop
          when 'OS Info'
            display_os_info(system_info.slice(:kernel, :os, :uptime))
          when 'Hardware Info'
            display_hardware_info(system_info.slice(:cpu, :ram, :disks, :gpu))
          when 'Network Info'
            display_network_info(system_info.slice(:network, :nic))
          end
        end

        break if exit_menu # Break outer loop if flag is true
      end

      break if exit_menu # Break outer loop if flag is true
    end

    Curses.close_screen
  end

  def self.draw_main_box
    @main_win.box('|', '-')
    @main_win.setpos(0, (Curses.cols - 11) / 2)
    @main_win.addstr('System Info')
    @main_win.setpos(Curses.lines - 1, Curses.cols - 4)
    @main_win.addstr('V1.0')
    @main_win.refresh
  end

  def self.draw_menu_box
    @menu_win.box('|', '-')
    @menu_win.setpos(0, 5)
    @menu_win.addstr('Menu')
    @menu_win.refresh
  end

  def self.draw_info_box(title = 'Information')
    @info_win.box('|', '-')
    title_position = @info_win.maxx - title.length - 2 # 2 for padding
    @info_win.setpos(0, title_position)
    @info_win.addstr(title)
    @info_win.refresh
  end

  def self.prepare_info_window(title)
    @info_win.clear
    draw_info_box(title)
    @info_win.setpos(3, 2)
  end

  def self.display_os_info(os_info)
    prepare_info_window('OS Information')
    display_info(os_info, @info_win)
    @info_win.refresh
  end

  def self.display_hardware_info(hardware_info)
    prepare_info_window('Hardware Information')

    # CPU and RAM on the left side
    left_row = 4
    left_row = display_cpu_info(hardware_info[:cpu], left_row)
    display_ram_info(hardware_info[:ram], left_row)

    # Disks and GPU on the right side
    right_row = 4
    right_col = 40 # Adjust this value to place it at the desired column
    right_row = display_disk_info(hardware_info[:disks], right_row, right_col)
    display_gpu_info(hardware_info[:gpu], right_row, right_col)

    @info_win.refresh
  end

  def self.display_cpu_info(cpu_info, start_row)
    @info_win.setpos(start_row, 2)
    @info_win.attron(Curses.color_pair(1)) { @info_win.addstr('CPU Information') }
    start_row += 1
    @info_win.setpos(start_row, 2)
    @info_win.addstr('--------------')
    start_row += 1
    @info_win.setpos(start_row, 2)
    display_info(cpu_info, @info_win, start_row, 4)
    start_row += cpu_info.keys.length + 1
    start_row
  end

  def self.display_ram_info(ram_info, start_row, col = 2)
    @info_win.setpos(start_row, col)
    @info_win.attron(Curses.color_pair(1)) { @info_win.addstr('RAM Information') }
    start_row += 1
    @info_win.setpos(start_row, col)
    @info_win.addstr('--------------')
    start_row += 1
    display_info(ram_info, @info_win, start_row, 4, col)
    start_row += ram_info.keys.length + 1
    start_row
  end

  def self.display_disk_info(disk_info, start_row, col = 2)
    @info_win.setpos(start_row, col)
    @info_win.attron(Curses.color_pair(1)) { @info_win.addstr('Disk Information')}
    start_row += 1
    @info_win.setpos(start_row, col)
    @info_win.addstr('---------------')
    start_row += 1
    display_info({ disks: disk_info }, @info_win, start_row, 0, col)
    start_row += (disk_info.length * 3) + 1
    start_row
  end

  def self.display_gpu_info(gpu_info, start_row, col = 2)
    @info_win.setpos(start_row, col)
    @info_win.attron(Curses.color_pair(1)) { @info_win.addstr('GPU Information')}
    start_row += 1
    @info_win.setpos(start_row, col)
    @info_win.addstr('--------------')
    start_row += 1
    display_info(gpu_info, @info_win, start_row, 4, col)
    start_row += gpu_info.keys.length + 1
    start_row
  end

  def self.display_network_info(network_info)
    prepare_info_window('Network Information')
    display_info(network_info, @info_win)
    @info_win.refresh
  end

  def self.display_info(info_hash, win, row = 4, indent = 0, col = 2)
    info_hash.each do |key, value|
      row = handle_value_type(value, win, row, indent, col, key)
    end
    row
  end

  def self.handle_value_type(value, win, row, indent, col, key)
    formatted_key = key.to_s.gsub('_', ' ').split.map(&:capitalize).join(' ')
    if value.is_a?(Hash)
      display_hash_value(value, win, row, indent, col, formatted_key)
    elsif value.is_a?(Array)
      display_array_value(value, win, row, indent, col)
    else
      display_scalar_value(value, win, row, indent, col, formatted_key)
    end
  end

  def self.display_hash_value(value, win, row, indent, col, key)
    win.setpos(row, col + indent)
    win.addstr("#{key}: ")
    display_info(value, win, row, indent + 4, col)
  end

  def self.display_array_value(value, win, row, indent, col)
    value.each do |item|
      if item.is_a?(Hash)
        row = display_info(item, win, row, indent + 4, col)
      else
        win.setpos(row, col + indent + 4)
        win.addstr(item.to_s)
        row += 1
      end
    end
    row
  end

  def self.display_scalar_value(value, win, row, indent, col, key)
    win.setpos(row, col + indent)
    win.addstr("#{key}: #{value}")
    row + 1
  end

  def self.setup_readline
    # Set up Readline for proper terminal settings
    Readline.emacs_editing_mode
    # the above line sets Readline to emacs_editing_mode so that terminals behave like they're supposed to
    Readline.completion_append_character = ' '
    # we remove Readlines thing where it adds a space to the end of tab completes because it breaks the Curses cursor
    Readline.completion_proc = proc { |_s| [] }
    # here we basically are disabling tab completion all together. That's because for some reason it breaks the cursor
  end
  private_class_method :display_info, :setup_readline
end
