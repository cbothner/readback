# frozen_string_literal: true

# Displays concerts for regular public service readings on air.
class ConcertsController < EventsController
  private

  def calendar_id
    'umich.edu_u80len8s415j5n0rclpgmnco04@group.calendar.google.com'
  end
end
