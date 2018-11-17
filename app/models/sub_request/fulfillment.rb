# frozen_string_literal: true

class SubRequest
  # A Fulfillment is when a DJ takes another DJ’s slot in response to a
  # SubRequest.
  class Fulfillment
    def initialize(sub_request, dj)
      @sub_request = sub_request
      @dj = dj

      set_attributes
    end

    def save
      ActiveRecord::Base.transaction do
        @sub_request.save
        @sub_request.episode.save
      end
    end

    private

    def set_attributes
      @sub_request.status = :confirmed
      @sub_request.episode.dj = @dj
    end
  end
end
