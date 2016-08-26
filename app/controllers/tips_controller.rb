class TipsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    @tip = Tip.new tip_params

    if @tip.save
      render json: @tip, status: :created
    else
      render json: @tip.errors, status: :unprocessable_entity
    end
  end

  private

  def tip_params
    hash = {}
    hash.merge! params.require(:tip).permit(:uid, :receipt_data, :product_id, :name, :message)
    # hash.merge! tip_value(params[:tip][:receipt_data])
  end

  #def tip_value data
    #receipt = receipt_fields data
  #end

  #def receipt_fields data
    #endpoint = Rails.env == 'production' ? 'buy' : 'sandbox'
    #uri = URI "https://#{endpoint}.itunes.apple.com/verifyReceipt"
    #req = Net::HTTP::Post.new(req, 'Content-Type' => 'application/json')
    #req.body = {"receipt-data" => data}
    #res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      #http.request req
    #end
    #json = JSON.parse res.body
  #end

end
