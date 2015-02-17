class UserUploadsController < ApplicationController
  include UserUploadsHelper
  include UserRoleHelper
  require 'csv'
  rescue_from UserUpload::InvalidFileError, with: :invalid_file
  rescue_from CSV::MalformedCSVError, with: :invalid_file
  before_filter :authenticate_user!
  before_filter :is_admin?

  def new
    @user_upload = UserUpload.new
  end

  def create
    if UserUpload.import_requirements?(params)
      @user_upload = UserUpload.new(user_uploads_params)
      if @new_users = @user_upload.save
        flash[:notice] = "upload successful"
        redirect_to uploaded_users_path(new_users: @new_users.length)
      else
        flash[:error] = "upload failed"
        redirect_to new_user_upload_path
      end
    else
      flash[:error] = "please select a file"
      redirect_to new_user_upload_path
    end
  end

  def uploaded_users
    @new_users = User.last(params[:new_users].to_i)
  end

private

  def invalid_file(msg)
    flash[:error] = "upload unsuccessful: please upload a file with the correct file type and formatting."
    redirect_to :back
  end
end