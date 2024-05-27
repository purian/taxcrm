class SalesController < ApplicationController
  def index
    year = params[:year] || Date.current.year.to_s
    @sales = Sale.where("strftime('%Y', created_at) = ?", year).to_a

    # Convert PraiseTax to numeric and filter out high values
    @sales = @sales.select do |sale|      
      sale.PraiseTax.to_f < 1_000_000
    end

    @total_sales_over_time = @sales.group_by { |sale| sale.created_at.to_date }.transform_values(&:count)
    @sales_amount_over_time = @sales.group_by { |sale| sale.created_at.to_date }.transform_values { |sales| sales.sum { |s| s.PraiseTax.to_f } }
    @sales_distribution_by_status = @sales.group_by(&:SaleStatusId_Name).transform_values(&:count)
    @average_sales_amount_by_month = @sales.group_by { |sale| sale.created_at.strftime('%B %Y') }.transform_values { |sales| sales.sum { |s| s.PraiseTax.to_f } / sales.size }
  end
end