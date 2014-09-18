class GenresController < ApplicationController
  include ApplicationHelper
  before_filter :find_genre, only: [:show, :edit, :destroy, :update]

  def index
    @genres = Genre.all
  end

  def show
  end

  def new 
    is_admin?
    @genre = Genre.new
  end 

  def create 
    is_admin?
    @genre = Genre.new(genre_params)
    if @genre.save 
      respond_to do |format|
        format.html do 
            flash[:notice] = "Genre added"
            redirect_to genres_path
        end 
        format.js {}
      end
    else
      flash[:alert] = "Genre failed to save"
      redirect_to new_genre_path
    end
  end 

  def edit 
    is_admin?
  end 

  def update 
    is_admin?
    if @genre.update(genre_params)
      flash[:notice] = "Update Successful!"
      redirect_to genre_path(@genre)
    else 
      flash[:error] = "Update Failed"
      redirect_to edit_genre_path
    end 
  end 

  def destroy 
    is_admin? 
    @genre.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to genres_path 
  end 

  private
  def genre_params
    params.require(:genre).permit(:name, :id)
  end 

  def find_genre
    @genre = Genre.find(params[:id])
  end 
end
