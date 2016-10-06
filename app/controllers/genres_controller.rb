class GenresController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!, only: [:new, :create, :edit, :destroy, :update]
  before_filter :find_genre, only: [:show, :edit, :destroy, :update]
  before_filter :is_admin?, only: [:new, :create, :edit, :destroy, :update]
  helper_method :sort_column, :sort_direction

  def index
    @genres = Genre.all.order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    respond_to do |format|
      format.html {}
      format.js {}
      format.json {render json: @genres.as_json}
    end
  end

  def show
    if params["sort"] == "sort_by"
      @books = @genre.books.joins(:authors).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    else
      @books = @genre.books.includes(:authors).order(sort_column("title") + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    end

    respond_to do |format|
      format.js
      format.html
      format.csv do
        send_data @genre.books.to_csv, filename: "#{@genre.name}-#{Date.today}.csv"
      end
      format.xls do
        send_data @genre.books.to_csv(col_sep: "\t"), filename: "#{@genre.name}-#{Date.today}.csv"
      end
    end
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      respond_to do |format|
        format.html do
            flash[:notice] = "Category added"
            redirect_to genres_path
        end
        format.js {}
      end
    else
      flash[:error] = "Category failed to save"
      redirect_to new_genre_path
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      flash[:notice] = "Update Successful"
      redirect_to genre_path(@genre)
    else
      flash[:error] = "Update Failed"
      redirect_to edit_genre_path
    end
  end

  def destroy
    if @genre.destroy
      flash[:notice] = "Delete Successful"
    else
      flash[:error] = "Delete Failed"
    end
    redirect_to genres_path
  end

private

  def find_genre
    @genre = Genre.find(params[:id])
  end

  def sort_column(column_name = nil)
    unless column_name
      params[:sort] ? params[:sort] : "name"
    else
      column_name
    end
  end

  def sort_direction(default = "asc")
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default
  end

  def genre_params
    params.require(:genre).permit(:name, :abbreviation, :id)
  end
end
