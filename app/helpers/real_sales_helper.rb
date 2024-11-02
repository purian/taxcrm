module RealSalesHelper
  def next_step_status_color(next_step_date)
    return 'text-gray-400' if next_step_date.nil?
    
    case
    when next_step_date.to_date < Date.current
      'text-red-500'    # Passed date - Red
    when next_step_date.to_date == Date.current
      'text-yellow-500' # Today - Yellow
    else
      'text-green-500'  # Future date - Green
    end
  end

  def next_step_status_icon(next_step_date)
    return '⚪' if next_step_date.nil?
    
    case
    when next_step_date.to_date < Date.current
      '🔴'  # Red circle
    when next_step_date.to_date == Date.current
      '🟡'  # Yellow circle
    else
      '🟢'  # Green circle
    end
  end
end
