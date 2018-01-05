module CatsHelper
  def valid?
     bool = false
     if current_user
       current_user.cats.each do |this_cat|
        bool = true if @cat.id == this_cat.id
      end
    end
    return bool
  end
end
