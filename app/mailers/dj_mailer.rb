class DjMailer < ApplicationMailer

  DJ_EMAIL_METHODS = {
    graduate: "You’re now a WCBN DJ!",
  }
  DJ_EMAIL_METHODS.each do |method, subject|
    define_method method do |dj|
      @dj = dj
      mail to: @dj.email, subject: subject
    end
  end

end
