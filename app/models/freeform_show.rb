class FreeformShow < ActiveRecord::Base
  belongs_to :semester
  belongs_to :dj
  has_many :show_instances, as: :show

  def different_dj_title
    "guest DJ"
  end
end
