# frozen_string_literal: true

class SubRequest
  # A Fulfillment is when a DJ takes another DJ’s slot in response to a
  # SubRequest.
  class Fulfillment
    def initialize(sub_request, fulfilling_dj)
      @sub_request = sub_request

      @asking_dj = sub_request.episode.dj
      @fulfilling_dj = fulfilling_dj

      set_attributes
    end

    def save
      ActiveRecord::Base.transaction do
        @sub_request.episode.save
        @sub_request.save
      end

      send_confirmation_email
    end

    private

    def set_attributes
      @sub_request.status = :confirmed
      @sub_request.episode.dj = @fulfilling_dj
    end

    def send_confirmation_email
      SubRequestMailer.fulfilled(@sub_request, asking_dj: @asking_dj)
                      .deliver_later
    end
  end
end
