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
  validates :website, format: {with: /(\Ahttp|\A\Z)/, message: "must start with “http://”"}

  with_options if: :um_affiliated? do |dj|
    dj.validates :umid, :um_dept, presence: true
    #dj.validates :umid, format: {with: /\A[0-9]{8}\Z/}
  end

  def semesters_count
    (freeform_shows.map(&:semester) + specialty_shows.map(&:semester))
      .uniq.count
  end

  def to_s
    dj_name.blank? ? first_name : dj_name
  end

  # TODO: Refactor to able_to_do_daytime_radio?
  def allowed_to_do_daytime_radio?
    return false if has_role? :no_daytime
    semesters_count > 1 || has_role?(:grandfathered_in)
  end

  def shows
    freeform_shows + specialty_shows + talk_shows
  end

  def website_name
    URI::parse(website || (return nil)).host.sub('www.','')
  end

  def image_url
    has_custom_picture? ? profile_picture : robot_picture_url
  end

  def has_custom_picture?
    false
  end

  def robot_picture_url
    "http://www.robohash.org/#{Digest::MD5.hexdigest(email)}?set=set3"
  end

end
