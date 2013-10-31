class CreateFeedbackEvents < ActiveRecord::Migration
  def change
    create_table :feedback_events do |t|
      t.references :submission_event, null: false, index: true
      t.boolean :accepted, null: false
      t.text :comment, null: true

      t.timestamps
    end
  end
end
