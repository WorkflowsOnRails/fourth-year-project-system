class CreateOralPresentations < ActiveRecord::Migration
  def change
    create_table :oral_presentations do |t|
      t.string :aasm_state
      t.string :venue, null: false
      t.date :date, null: false
      t.time :start, null: false
      t.time :finish, null: false
    end
  end
end
