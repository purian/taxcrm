module RealSalesHelper
  def status_color(status)
    {
      'overdue' => 'red',
      'today' => 'yellow',
      'upcoming' => 'green',
      'no_date' => 'gray'
    }[status]
  end

  def render_due_date_text(sale, status)
    case status
    when 'overdue'
      "(#{distance_of_time_in_words(sale.next_step_date, Date.current)} ago)"
    when 'upcoming'
      "(in #{distance_of_time_in_words(Date.current, sale.next_step_date)})"
    end
  end
end
