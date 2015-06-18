class Dj < ActiveRecord::Base
  AFFILIATED_UM_AFFILIATIONS = %w(student alumni faculty)
  UNAFFILIATED_UM_AFFILIATIONS = %w(community)
  UM_AFFILIATIONS = AFFILIATED_UM_AFFILIATIONS + UNAFFILIATED_UM_AFFILIATIONS

  has_and_belongs_to_many :specialty_shows
  has_many :freeform_shows
  has_many :talk_shows

  has_many :episodes
  
  serialize :roles, Array

  #validates :name, :phone, :email, presence: true
  #with_options if: :um_affiliated? do |dj|
    #dj.validates :umid, :um_dept, presence: true
    #dj.validates :umid, numericality: {only_integer: true,
                                       #greater_than_or_equal_to: 1111_1111,
                                       #less_than_or_equal_to: 9999_9999}
  #end
  #validates :statement, presence: true, unless: :um_affiliated?

  def um_affiliated?
    AFFILIATED_UM_AFFILIATIONS.include? um_affiliation
  end

  def semesters_count
    (freeform_shows.map(&:semester) + specialty_shows.map(&:semester))
      .uniq.count
  end

  # TODO: Refactor to able_to_do_daytime_radio?
  def allowed_to_do_daytime_radio?
    semesters_count > 1
  end
end
