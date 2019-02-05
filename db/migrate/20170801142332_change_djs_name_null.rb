class ChangeDjsNameNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :djs, :name, false
  end
end
