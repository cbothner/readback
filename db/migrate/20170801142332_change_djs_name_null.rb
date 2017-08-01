class ChangeDjsNameNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :djs, :name, false
  end
end
