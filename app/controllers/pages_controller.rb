require 'RMagick'
include Magick

class PagesController < ApplicationController

  def home
  end

  def tweet
    img = ImageList.new("#{Rails.root}/public/base_img.jpg")
    txt = Draw.new
    c = 0
    (params[:message].length/50 + 1).times do |i|
      img.annotate(txt, 0, 0, 0, 1000 - c, params[:message][(0 + 50 * i)..50*(i+1)]) {
        txt.gravity = Magick::SouthGravity
        txt.pointsize = 50
        txt.stroke = '#000000'
        txt.fill = '#ffffff'
        txt.font_weight = Magick::BoldWeight
        c += 100
      }
    end

    img.format = 'jpeg'
    fname = SecureRandom.hex(20)
    path = "#{Rails.root}/public/#{fname}.jpg"
    img.write(path)
    render json: { status: 200, path: path }
  end

  def connect_twitter
    redirect_to "/auth/twitter?path=#{params['path']}"
  end

  def return_twitter
    token = request.env['omniauth.auth'].credentials['token']
    secret = request.env['omniauth.auth'].credentials['secret']
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = token
      config.access_token_secret = secret
    end
    client.update_with_media('', File.new(params[:path]))
    flash[:success] = 'Tweet successful'
    File.delete(params['path']) if File.exist?(params['path'])
    redirect_to root_path
  end

end
