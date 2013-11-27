class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines, id: false do |t|
      t.string :code, null: false
      t.datetime :timestamp, null: false
    end

    add_index :deadlines, :code, unique: true
  end
end
