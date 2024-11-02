class RealSalesController < ApplicationController
  before_action :set_real_sale, only: [:show, :timeline]

  def index
    @real_sales = RealSale.all
  end

  def dashboard
    @statistics = {
      overdue: RealSale.where('next_step_date < ?', Date.current).count,
      today: RealSale.where('DATE(next_step_date) = ?', Date.current).count,
      upcoming: RealSale.where('next_step_date > ?', Date.current).count,
      no_date: RealSale.where(next_step_date: nil).count
    }

    @status = params[:status] || 'overdue'
    @sales = fetch_sales_by_status(@status)
  end

  def analytics
    @real_sales = RealSale.all
    
    @analytics_data = {
      by_status: {
        overdue: @real_sales.where('next_step_date < ?', Date.current).count,
        today: @real_sales.where('DATE(next_step_date) = ?', Date.current).count,
        upcoming: @real_sales.where('next_step_date > ?', Date.current).count,
        no_date: @real_sales.where(next_step_date: nil).count
      },
      by_month: @real_sales.group_by_month(:next_step_date).count,
      by_status_name: @real_sales.group(:sale_status_name).count
    }

    respond_to do |format|
      format.html
      format.json { render json: @analytics_data }
    end
  end

  def show
    @real_sale = RealSale.find(params[:id])
    @is_turbo_frame = turbo_frame_request?
    
    if @is_turbo_frame
      render layout: false
    end
  end

  def timeline
    @timeline_events = @real_sale.timeline_events # You'll need to define this association
    
    respond_to do |format|
      format.html
      format.json { render json: @timeline_events }
    end
  end

  private

  def set_real_sale
    @real_sale = RealSale.find(params[:id])
  end

  def fetch_sales_by_status(status)
    case status
    when 'overdue'
      RealSale.where('next_step_date < ?', Date.current)
              .order(next_step_date: :asc)
    when 'today'
      RealSale.where('DATE(next_step_date) = ?', Date.current)
              .order(next_step_date: :asc)
    when 'upcoming'
      RealSale.where('next_step_date > ?', Date.current)
              .order(next_step_date: :asc)
    when 'no_date'
      RealSale.where(next_step_date: nil)
              .order(created_at: :desc)
    else
      RealSale.none
    end
  end
end
