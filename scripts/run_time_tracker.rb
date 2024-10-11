# /Users/jack/personal/workramp-timetracking/scripts/run_time_tracker.rb

require_relative '../lib/time_tracker'

class TimeTracker
  def start
    puts "Time tracking started."
  end
end

tracker = TimeTracker.new
tracker.print_total_time_spent_by_content
tracker.print_median_time_spent_by_content