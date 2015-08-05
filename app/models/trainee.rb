class Trainee < ActiveRecord::Base
  Acceptance = Struct.new(:timestamp, :dj_id, :message) do
    def accepted?
      !timestamp.nil?
    end
  end
  serialize :demotape, Acceptance
  serialize :broadcasters_exam, Acceptance

  include Person

  include Authority::Abilities

  validates :name, :phone, :email, presence: true

  belongs_to :dj

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
