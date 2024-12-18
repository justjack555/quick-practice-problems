require 'date'

class ApiRateLimiter
  def initialize(max_calls_per_minute = 10)
    @max_calls_per_minute = max_calls_per_minute
    @calls = {}
  end

  def api_call(user_id)
    unless @calls[user_id]
      @calls[user_id] = [DateTime.now]

      return true
    end

    remove_old_calls(user_id)
    raise StandardError, 'RATE_LIMIT_EXCEEDED' if @calls[user_id].length >= 10

    @calls[user_id].push(DateTime.now)

    true
  end

  private

  def remove_old_calls(user_id)
    current_time_ms = DateTime.now.strftime('%Q').to_i
    one_min_ago = DateTime.strptime((current_time_ms - 1000 * 60).to_s, '%Q')

    until @calls[user_id].empty?
      break unless @calls[user_id].first < one_min_ago

      @calls[user_id].shift
    end
  end
end
