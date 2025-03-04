class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :description, null: false
      t.timestamps
    end

    add_index :links, :url
    add_index :links, :description
  end
end
