class Dj < ActiveRecord::Base
  include Person

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include Authority::UserAbilities
  include Authority::Abilities
  rolify

  has_and_belongs_to_many :specialty_shows
  has_many :freeform_shows
  has_many :talk_shows

  has_many :episodes

  has_one :trainee
  
  serialize :roles, Array

  validates :name, :phone, :email, presence: true

  def semesters_count
    (freeform_shows.map(&:semester) + specialty_shows.map(&:semester))
      .uniq.count
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
