class CreatePosterFairForms < ActiveRecord::Migration
  def change
    create_table :poster_fair_forms do |t|
      t.string :aasm_state
      t.text :requests
    end
  end
end
