class CreatePuids < ActiveRecord::Migration
  def change
    create_table :puids do |t|
      t.string :puid
      t.integer :user_id
    end
  end
end
