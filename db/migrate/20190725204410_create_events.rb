class CreateEvents < ActiveRecord::Migration[5.1]
  def change

    create_table :sources do |t|
      t.string :name, null: false
      t.string :url, null: true
      t.string :page_date_format, null: false
      t.index :url, unique: false
      t.timestamps
    end

    create_table :events do |t|
      t.references :source, null: false, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :title, null: false
      t.string :url, null: true
      t.index :start_at, unique: false
      t.index :end_at, unique: false
      t.index :title, unique: false
      t.timestamps
    end

  end
end
