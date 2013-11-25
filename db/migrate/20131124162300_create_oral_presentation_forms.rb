class CreateOralPresentationForms < ActiveRecord::Migration
  def change
    create_table :oral_presentation_forms do |t|
      t.string :aasm_state
      t.text :available_times
      t.text :accepted_user_ids
    end
  end
end
