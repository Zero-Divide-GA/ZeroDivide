class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :email
      t.string :zip
      t.string :language

      t.timestamps null: false
    end
  end
end
