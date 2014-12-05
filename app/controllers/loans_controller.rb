class LoansController < ApplicationController

  include UserRoleHelper
  include LoanHelper

  before_filter :is_librarian?, only: [:new, :create, :renew, :return, :index]
  before_filter :authenticate_user!
  before_filter :find_loan, only: [:renew, :return, :show]

  def new
    @user = User.find_by(id: params[:user_id])
    unless @user.good_to_borrow?
      flash[:error] = "User Can Not Borrow at This Time"
      redirect_to user_path(@user.id) and return 
    end 
    @loan = Loan.new(user: @user)
  end

  def create
    @loan = Loan.new(loan_params)
    unless @loan.user.good_to_borrow?
      flash[:error] = "User Can Not Borrow at This Time"
      redirect_to user_path(@loan.user.id) and return 
    end 
    if @loan.save 
      flash[:notice] = "Loan Created"
    else 
      flash[:alert] = "Loan Creation Failed"
    end 
    redirect_to user_path(@loan.user_id)
  end

  def renew
    if @loan.renew_loan
      flash[:notice] = "Loan Renewed"
    else
      flash[:alert] = "Loan Limit Reached"
    end
    redirect_to user_path(@loan.user_id)
  end

  def return
    if @loan.return_loan
      flash[:notice] = "Loan Returned"
    else
      flash[:alert] = "Loan Return Faild"
    end
    redirect_to user_path(@loan.user_id)
  end

  def show
    if !is_given_user_or_librarian?(@loan.user) then
      flash[:error] = "You are not authorized" 
      redirect_to root_path
    end
  end

  def index
    @loans = Loan.all
  end
end