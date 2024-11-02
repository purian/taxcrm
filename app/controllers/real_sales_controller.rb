class RealSalesController < ApplicationController
  before_action :set_real_sale, only: [:show, :timeline]

  def index
    @real_sales = RealSale.all
  end

  def dashboard
    @real_sales = if params[:sale_id]
      Sale.find(params[:sale_id]).real_sales
    else
      RealSale.all
    end

    @overdue_sales = @real_sales.where('next_step_date < ?', Date.current)
    @today_sales = @real_sales.where('DATE(next_step_date) = ?', Date.current)
    @upcoming_sales = @real_sales.where('next_step_date > ?', Date.current)
    
    # Add counts for quick statistics
    @statistics = {
      total: @real_sales.count,
      overdue: @overdue_sales.count,
      today: @today_sales.count,
      upcoming: @upcoming_sales.count
    }

    respond_to do |format|
      format.html
      format.json { render json: @statistics }
    end
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
    respond_to do |format|
      format.html
      format.json { render json: @real_sale }
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
end
