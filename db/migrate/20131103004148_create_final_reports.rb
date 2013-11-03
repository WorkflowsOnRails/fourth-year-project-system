class CreateFinalReports < ActiveRecord::Migration
  def change
    create_table :final_reports do |t|
      t.string :aasm_state
    end
  end
end
