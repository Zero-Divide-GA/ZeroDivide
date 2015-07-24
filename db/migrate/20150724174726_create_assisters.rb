class CreateAssisters < ActiveRecord::Migration
  def change
    create_table :assisters do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :email
      t.string :zip
      t.string :password
      t.string :language
      t.string :addlanguage

      t.timestamps null: false
    end
  end
end
