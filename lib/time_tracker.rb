require 'httparty'
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
  TIME_TRACKING_ENDPOINT = 'https://www.workramp.com/engineering/interviews/time-tracking-api.php'.freeze

  def initialize
    @log_data = nil
  end

  def print_total_time_spent_by_content
    total_time_spent_by_content.transform_values(&:sum).each do |content, total_time_spent|
      _, content_type, content_id = content.split('/')
      puts "#{content_type == 'tasks' ? 'Task ' : 'Challenge '} #{content_id}: #{total_time_spent} minutes"
    end
  end

  def print_median_time_spent_by_content
    median_time_spent_by_content = total_time_spent_by_content.transform_values do |time_spent_values|
                                              time_spent_values.sort[time_spent_values.size / 2]
                                            end
    median_time_spent_by_content.each do |content, median_time_spent|
      _, content_type, content_id = content.split('/')
      puts "#{content_type == 'tasks' ? 'Task ' : 'Challenge '} #{content_id}: #{median_time_spent} minutes"
    end
  end

  private

  def total_time_spent_by_content
    fetch_data if @log_data.nil?

    @log_data.group_by { |log| log['content_url'] }.transform_values { |logs| logs.map { |log| log['time_spent'] } }
  end

  def fetch_data
    response = HTTParty.get(TIME_TRACKING_ENDPOINT)
    if response.success?
      @log_data = response['logs']
    else
      raise "Failed to fetch data: #{response.code} #{response.message}"
    end
  end
end
