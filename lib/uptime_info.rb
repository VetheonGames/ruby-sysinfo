# frozen_string_literal: true

class UptimeInfo
  def self.gather_info
    uptime_seconds = `cat /proc/uptime`.split.first.to_i
    uptime_info = {}

    # Calculate time components
    minutes, seconds = uptime_seconds.divmod(60)
    hours, minutes = minutes.divmod(60)
    days, hours = hours.divmod(24)
    weeks, days = days.divmod(7)
    months, weeks = weeks.divmod(4)
    years, months = months.divmod(12)

    # Populate the hash only if the value is greater than zero
    uptime_info[:years] = years if years.positive?
    uptime_info[:months] = months if months.positive?
    uptime_info[:weeks] = weeks if weeks.positive?
    uptime_info[:days] = days if days.positive?
    uptime_info[:hours] = hours if hours.positive?
    uptime_info[:minutes] = minutes if minutes.positive?
    uptime_info[:seconds] = seconds if seconds.positive?

    # Format the uptime string
    formatted_uptime = uptime_info.map { |k, v| "#{v} #{k.to_s.capitalize}" }.join(' : ')

    { uptime: formatted_uptime }
  end
end
