class UsersController < ApplicationController

  require 'push_notification'

  def show
    Rails.logger.debug "===============> inside show of UsersController <==============="

    @products = Product.all(:conditions => "id <= 3")
  end

  def register
    Rails.logger.debug "===============> inside register of UsersController <==============="
    Rails.logger.debug "===============> JSON.parse(params[:registration]) : #{JSON.parse(params[:registration])} <==============="

    registration_data = JSON.parse(params[:registration])

    Rails.logger.debug "===============> registration_data['user'] : #{registration_data["user"].inspect} <==============="
    Rails.logger.debug "===============> registration_data['device'] : #{registration_data["device"].inspect} <==============="

    user = User.new(registration_data["user"])
    user.device = Gcm::Device.new(registration_data["device"])
    if user.save!
      # render :json => { :status => 'success' }.to_json
      process_result 'success'
    else
      # render :json => { :status => 'failure' }.to_json
      process_result 'failure'
    end
  end

  def attach_product
    Rails.logger.debug "===============> inside register of UsersController <==============="
    Rails.logger.debug "===============> JSON.parse(params[:attach_product]) : #{JSON.parse(params[:attach_product])} <==============="

    attach_data = JSON.parse(params[:attach_product])

    attach_data[:brand] = attach_data[:brand].present? ? attach_data[:brand] : "---"

    user = User.find_by_email(attach_data[:email])

    product = Product.find_by_name_and_brand(attach_data[:name], attach_data[:brand])
    product ||= user.products.build({ :name => attach_data[:name], :brand => attach_data[:brand] })

    if user.products.include?(product)
      process_result 'exists'
    else
      user_prod = user.user_products.build
      user_prod.product = product

      if user_prod.save!
        process_result 'success'
      else
        process_result 'failure'
      end
    end

  end

  def test_notification
    user = User.find(4)

    PushNotification.send_notification(user.device, "Testing sample notification")

    process_result 'sucess'
  end

  def process_result status = nil
    respond_to do |format|
      format.html {
        render :json => {
            :status => status
          }.to_json
      }
    end
  end
  
end
