class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.date :dob
      t.integer :gender, null: false
      t.integer :role, null: false

      t.timestamps
    end
  end
end
