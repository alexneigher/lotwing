class CheckRequestSearchService
  attr_reader :filters_applied

  def initialize(params, dealership)
    @filters_applied = false
    @dealership = dealership

    @is_check = params[:is_check].presence
    @is_cash = params[:is_cash].presence
    @department = params[:department].presence
    @amount_requested = params[:amount_requested].presence
    @stock_number = params[:stock_number].presence
    @make = params[:make].presence
    @model = params[:model].presence

  end


  def perform
    check_requests = base_query

    check_requests = filter_by_is_check(check_requests) if @is_check
    check_requests = filter_by_is_cash(check_requests) if @is_cash
    check_requests = filter_by_department(check_requests) if @department
    check_requests = filter_by_amount_requested(check_requests) if @amount_requested
    check_requests = filter_by_stock_number(check_requests) if @stock_number
    check_requests = filter_by_make(check_requests) if @make
    check_requests = filter_by_model(check_requests) if @model
    check_requests = filter_by_payable_to(check_requests) if @payable_to
    check_requests = filter_by_description(check_requests) if @description

    return check_requests
  end



  private
    def filter_by_description(check_requests)
      @filters_applied=true
      check_requests.where("description ILIKE ?", "%#{@description}%")
    end

    def filter_by_payable_to(check_requests)
      @filters_applied=true
      check_requests.where("payable_to ILIKE ?", "%#{@payable_to}%")
    end

    def filter_by_model(check_requests)
      @filters_applied=true
      check_requests.where("model ILIKE ?", "%#{@model}%")
    end

    def filter_by_make(check_requests)
      @filters_applied=true
      check_requests.where("make ILIKE ?", "%#{@make}%")
    end

    def filter_by_stock_number(check_requests)
      @filters_applied=true
      check_requests.where("stock_number ILIKE ?", "%#{@stock_number}%")
    end

    def filter_by_amount_requested(check_requests)
      @filters_applied=true
      check_requests.where("amount_requested ILIKE ?", "%#{@amount_requested}%")
    end

    def filter_by_is_check(check_requests)
      @filters_applied=true
      check_requests.where(is_check: true)
    end

    def filter_by_is_cash(check_requests)
      @filters_applied=true
      check_requests.where(is_cash: true)
    end

    def filter_by_department(check_requests)
      @filters_applied=true
      check_requests.where(department: @department)
    end

    def base_query
      @dealership.check_requests
    end
end