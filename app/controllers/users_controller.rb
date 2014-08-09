class UsersController < ApplicationController

  require 'push_notification'
  require 'search_users'

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
    Rails.logger.debug "===============> inside attach_product of UsersController <==============="
    Rails.logger.debug "===============> JSON.parse(params[:attach_product]) : #{JSON.parse(params[:attach_product])} <==============="

    attach_data = JSON.parse(params[:attach_product])

    user = User.find_by_email(attach_data["email"])

    product = Product.find_by_name(attach_data["name"])

    if product.present? and !user.products.include?(product)
      user_prod = user.user_products.build
      user_prod.product = product
      user_prod.save!
    else
      user.products.create({ :name => attach_data["name"] })
    end

    process_result 'success'

  end

  def send_review_request
    Rails.logger.debug "===============> inside send_review_request of UsersController <==============="
    Rails.logger.debug "===============> JSON.parse(params[:review_request]) : #{JSON.parse(params[:review_request])} <==============="

    request_data = JSON.parse(params[:review_request])

    product = Product.find_by_name(request_data["product_name"])
    receiver = User.find_by_email(request_data["receiver_email"])
    sender = User.find_by_email(request_data["sender_email"])
    request_msg = request_data["message"]

    Rails.logger.debug "product : #{product.inspect}"

    PushNotification.send_notification(sender, receiver, product, request_msg)

    process_result 'success'
  end

  def send_review_response
    Rails.logger.debug "===============> inside send_review_request of UsersController <==============="
    Rails.logger.debug "===============> JSON.parse(params[:review_response]) : #{JSON.parse(params[:review_response])} <==============="

    response_data = JSON.parse(params[:review_response])

    receiver = User.find_by_email(response_data["receiver_email"])
    sender = User.find_by_email(response_data["sender_email"])
    response_msg = response_data["status"].downcase == "accept" ? "#{sender.name} accepted your review request. Further details will be sent via mail" : "#{sender.name} rejected your review request."

    PushNotification.send_notification(sender, receiver, nil, response_msg)

    process_result 'success'
  end

  def search_users
    Rails.logger.debug "===============> inside search_users of UsersController <==============="
    Rails.logger.debug "===============> JSON.parse(params[:search]) : #{JSON.parse(params[:search])} <==============="

    search_data = JSON.parse(params[:search])

    user = User.find_by_email(search_data["user_email"])

    result = SearchUsers.start_searching(user.gps_latitude, user.gps_longitude, search_data["product_name"], 
                                                                user.work_place, user.native_location, user.language)

    render :json => result.to_json

  end

  def list_user_products
    Rails.logger.debug "===============> inside list_user_products of UsersController <==============="

    user = User.find_by_email(params[:email])

    render :json => { :products => user.products }.to_json
  end

  def owner_details
    Rails.logger.debug "===============> inside owner_details of UsersController <==============="

    user = User.find_by_email(params[:email])

    render :json => { :user => user }.to_json
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
  
  def test_notification
    user = User.find(4)
    product = Product.first

    PushNotification.send_notification(user, product, "Testing sample notification")

    process_result 'sucess'
  end

end
