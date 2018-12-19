class About < ApplicationRecord
  self.table_name = 'about' # table name is 'abouts' by default

  has_many_attached :images
  
  after_update_commit :purge_detached_images

  private

  def purge_detached_images
    images.attachments.preload(:blob).each do |attachment|
      attachment.purge_later unless about.include? attachment.signed_id
    end
  end
end
