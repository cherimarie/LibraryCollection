class InventoryController < ApplicationController
  include UserRoleHelper
  before_filter :is_admin?

  def genre_select
    @genres = Genre.all
  end

  def checklist
    @genre = Genre.find_by(params[:genre_id]) if params[:genre_id]
    render layout: false
  end

  def update_checklist_item

  end
end