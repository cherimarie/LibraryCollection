module UsersHelper

  def user_params
    params.require(:user).permit( :email, :password, :password_confirmation, :remember_me,
                                  :notes, :name, :phone, :preferred_first_name, :do_not_lend,
                                  :address, :city, :state, :zip, :identification )
  end

  def librarian_user?
    if current_user
      if current_user.has_role? :librarian
        return true
      elsif current_user.has_role? :admin
        return true
      end
    end
    return false
  end


  def admin_user?
    if current_user
      if current_user.has_role? :admin
        return true
      end
    end
    return false
  end

end
