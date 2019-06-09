class CompaniesController < ApplicationController

  # GET /companies
  # GET /companies.json
  def index
    companies = Company.all
    render json: companies, status: 200
  end

  def view_company
    user = User.find(params[:user_id])
    company = Company.find(user.company_id)
    if $redis.get(params['user_id']) == nil
      company.unique_views = company.unique_views+1
    else
      $redis.set(params['user_id'], params['company_id'])
    end
    unless company.id.to_s == params[:company_id]
      render json: {error: "user and company doesnt belong to each other"}
    end
    company.total_views = company.total_views+1
    if company.save
      render json: company, status: 200
    else
      render json: company.errors, status: 422
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    company = Company.new(company_params)

    if company.save
      render json: company, status: 200
    else
      render json: company.errors, status: 422
    end
  end

  private
    def company_params
      params.require(:company).permit(:name, :address)
    end
end
