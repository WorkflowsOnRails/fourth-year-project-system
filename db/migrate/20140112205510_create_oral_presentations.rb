class CreateOralPresentations < ActiveRecord::Migration
  def change
    create_table :oral_presentations do |t|
      t.string :aasm_state
      t.string :venue, null: false
      t.datetime :start, null: false
      t.datetime :finish, null: false
    end
  end
end
