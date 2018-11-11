# frozen_string_literal: true

module SubRequestsHelper
  def fulfilled?
    request_scope == :fulfilled
  end

  def other_request_scope
    if fulfilled?
      :unfulfilled
    else
      :fulfilled
    end
  end
end
