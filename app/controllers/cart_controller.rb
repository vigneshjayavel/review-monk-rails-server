class CartController < ApplicationController
  def review_order
  end

  def payment
    user = User.find_by_email(params[:user_email])

    params[:product].each do |k,product|
      if product["status"] == "yes"
        prod = Product.find_by_name(product["name"])

        if prod.present? and !user.products.include?(prod)
          user_prod = user.user_products.build
          user_prod.product = prod
          user_prod.save!
        else
          user.products.create({ :name => product["name"] })
        end
      elsif product["status"] == "later"
      else
      end
        
    end
  end
end
