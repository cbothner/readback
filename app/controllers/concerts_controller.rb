# frozen_string_literal: true

# Displays concerts for regular public service readings on air.
class ConcertsController < ApplicationController
  def index
    @concerts = FetchEvents.from(calendar_url).decorate
  end
end
