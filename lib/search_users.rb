class SearchUsers
  def self.start_searching(lati, longi, prod_name, company, hometown, language)
    puts "inside start_searching"

    product = Product.find_by_name(prod_name)

    return {:status => 'failure'} if product.blank?

    product_id = product.id

    @latitude = lati
    @longitude = longi

    #Convert degrees to radian
    @latitude = @latitude * Math::PI / 180
    @longitude = @longitude * Math::PI / 180
    #@latitude = self.toradian(@latitude)
    #@longitude = self.toradian(@longitude)

    #Required distance
    @d = 5.000000
    #Radius of Earth
    @R = 6371.000000
    @r = @d/@R

    #p @r
    @lat_max = @latitude + @r
    @lat_min = @latitude - @r
    #p @lat_max      
    #p @lat_min

    #Setting longitude limit
    #@lat_t = Math.asin(Math.sin(@latitude) / Math.cos(@r))
    @del_lon = Math.asin(Math.sin(@r) / Math.cos(@latitude))
    @lon_max = @longitude + @del_lon
    @lon_min = @longitude - @del_lon
    #if @lon_min < -180 and @lon_max > 180

	@company = company
	@hometown = hometown
	@language = language

    usernames = []
    distances = []
    weighteddistances = []
    index = -1
    @lat_min_degree = @lat_min * 180 / Math::PI
    @lat_max_degree = @lat_max * 180 / Math::PI
    @lon_min_degree = @lon_min * 180 / Math::PI
    @lon_max_degree = @lon_max * 180 / Math::PI

    query_string = "select u.name, u.gps_latitude, u.gps_longitude, u.work_place, u.native_location, u.language 
    				from users u, user_products up
    				where ( u.id = up.user_id AND up.product_id = #{product_id} AND
    						u.gps_latitude >= '#{@lat_min_degree}' AND u.gps_latitude <= '#{@lat_max_degree}') AND 
    						(u.gps_longitude >=  '#{@lon_min_degree}' AND  u.gps_longitude <=  '#{@lon_max_degree}')"


    ActiveRecord::Base.connection.execute(query_string).each do |res|
      @latitude2 = res[1] * Math::PI / 180
      @longitude2 = res[2] * Math::PI / 180
      @dist = Math.acos(Math.sin(@latitude) * Math.sin(@latitude2) + Math.cos(@latitude) * Math.cos(@latitude2) * Math.cos(@longitude - @longitude2)) * @R
      index = index + 1
      usernames[index] = res[0]
      distances[index] = @dist

	  @percent = 0

	  #considering res[3] as company name, res[4] as hometown and res[5] as language
	  if @company == res[3]
		@percent = @percent + 20
	  end
	  if @hometown == res[4]
	    @percent = @percent + 15
	  end
	  if @language == res[5]
	    @percent = @percent + 10
	  end

	  weighteddistances[index] = distances[index] - (distances[index] * @percent) / 100.00
    end

    for i in 0..index
      for j in i+1..index
        if weighteddistances[i] > weighteddistances[j] then 
          temp = distances[i]
          distances[i] = distances[j]
          distances[j] = temp
          temp = weighteddistances[i]
          weighteddistances[i] = weighteddistances[j]
          weighteddistances[j] = temp
          temp = usernames[i]
          usernames[i] = usernames[j]
          usernames[j] = temp
        end
      end
    end

    user_list = []
    distance_list = []
    for i in 0..index
      puts usernames[i]
      user_list << User.find_by_name(usernames[i])
      distance_list << distances[i]
    end

    if user_list.blank?
    	return {:status => 'failure'}
    else
    	return {:status => 'success', :users => user_list, :distances => distance_list}
    end
  end
end