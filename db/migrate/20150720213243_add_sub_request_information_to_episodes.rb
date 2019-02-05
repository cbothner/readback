class AddSubRequestInformationToEpisodes < ActiveRecord::Migration[5.2]
  def change
    change_table :episodes do |t|
      t.string :sub_request_information
      t.string :sub_request_group
    end
  end
end
