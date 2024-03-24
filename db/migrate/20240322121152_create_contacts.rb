class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :number
      t.references :user
      t.timestamps
    end
  end
end
