# frozen_string_literal: true

module SubRequests
  # @see SubRequest::Fulfillment
  class FulfillmentsController < ApplicationController
    before_action :set_sub_request

    # @route [POST] /sub_requests/1/fulfillments
    def create
      fulfillment = SubRequest::Fulfillment.new @sub_request, current_dj

      if fulfillment.save
        redirect_to(
          @sub_request.episode.show,
          notice: "You’ve signed up to cover #{@sub_request.episode.show.name}!"
        )
      else
        render 'sub_requests#show', notice: @sub_request.errors.full_messages
      end
    end

    private

    def set_sub_request
      @sub_request = SubRequest.includes(episode: %i[dj show])
                               .find(params[:sub_request_id])
    end
  end
end
