class CreatePuids < ActiveRecord::Migration
  def change
    create_table :puids do |t|
      t.string :puid, null: false, index: true
      t.belongs_to :user
      t.string :description, null: true
    end
  end
end
