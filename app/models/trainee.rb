class Trainee < ActiveRecord::Base
  include Person

  include Authority::Abilities

  with_options if: :um_affiliated? do |dj|
    dj.validates :umid, :um_dept, presence: true
    dj.validates :umid, numericality: {only_integer: true}
  end
  validates :statement, presence: true, unless: :um_affiliated?

  has_many :episodes

  def sent_email
    if most_recent_email.to_i == 0
      "Never emailed."
    else
      "#{most_recent_email.to_i}-day email sent."
    end
  end

end
