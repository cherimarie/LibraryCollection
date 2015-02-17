class GenresController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!, only: [:new, :create, :edit, :destroy, :update]
  before_filter :find_genre, only: [:show, :edit, :destroy, :update]
  before_filter :is_admin?, only: [:new, :create, :edit, :destroy, :update]

  def index
    @genres = Genre.all.order('name ASC')
  end

  def show
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
  def genre_params
    params.require(:genre).permit(:name, :abbreviation, :id)
  end

  def find_genre
    @genre = Genre.find(params[:id])
  end
end
