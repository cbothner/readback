class Dj < ActiveRecord::Base
  AFFILIATED_UM_AFFILIATIONS = %w(student alumni faculty)
  UNAFFILIATED_UM_AFFILIATIONS = %w(community)
  UM_AFFILIATIONS = AFFILIATED_UM_AFFILIATIONS + UNAFFILIATED_UM_AFFILIATIONS
  AFFILIATION_NAMES = {'student' => "Student", 'alumni' => "Alumni",
                       'faculty' => "Faculty/Staff", 'community' => "Community Advisor"}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include Authority::UserAbilities
  include Authority::Abilities
  rolify

  has_and_belongs_to_many :specialty_shows
  has_many :freeform_shows
  has_many :talk_shows

  has_many :episodes
  
  serialize :roles, Array

  validates :name, :phone, :email, presence: true
  with_options if: :um_affiliated? do |dj|
    dj.validates :umid, :um_dept, presence: true
    dj.validates :umid, numericality: {only_integer: true}
  end
  validates :statement, presence: true, unless: :um_affiliated?

  def um_affiliated?
    AFFILIATED_UM_AFFILIATIONS.include? um_affiliation
  end

  def um_id
    s = umid.to_s
    "#{s[0..3]} #{s[4..7]}"
  end

  def semesters_count
    (freeform_shows.map(&:semester) + specialty_shows.map(&:semester))
      .uniq.count
  end

  def first_name
    name.split(' ').first
  end

  def to_s
    dj_name.blank? ? first_name : dj_name
  end

  # TODO: Refactor to able_to_do_daytime_radio?
  def allowed_to_do_daytime_radio?
    semesters_count > 1 || has_role?(:grandfathered_in)
  end

  def shows
    freeform_shows + specialty_shows + talk_shows
  end

  def website_name
    URI(website || (return nil)).host.sub('www.','')
  end

end
