class SubRequestMailerPreview < ActionMailer::Preview

  def request_of_group
    SubRequestMailer.request_of_group SubRequest.needs_sub_in_group.first.id
  end

  def request_of_all
    SubRequestMailer.request_of_all SubRequest.needs_sub.first.id
  end

  def fulfilled
    SubRequestMailer.fulfilled SubRequest.confirmed.first.id
  end

  def unfulfilled
    SubRequestMailer.unfulfilled SubRequest.needs_sub.first.id
  end

  def reminder
    SubRequestMailer.reminder SubRequest.confirmed.first.id
  end

end
