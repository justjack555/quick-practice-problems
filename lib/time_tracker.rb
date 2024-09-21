# The TimeTracker class provides a simple way to track the duration of time
# between a start and stop event. It records the start time when the `start`
# method is called and the end time when the `stop` method is called. The
# elapsed time can be retrieved using the `elapsed_time` method.
#
# Example usage:
#   tracker = TimeTracker.new
#   tracker.start
#   # ... some time passes ...
#   tracker.stop
#   puts tracker.elapsed_time
class TimeTracker
  def initialize
    @start_time = nil
    @end_time = nil
  end

  def start
    @start_time = Time.now
  end

  def stop
    @end_time = Time.now
  end

  def elapsed_time
    return nil unless @start_time && @end_time

    @end_time - @start_time
  end
end
