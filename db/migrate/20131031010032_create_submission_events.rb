class CreateSubmissionEvents < ActiveRecord::Migration
  def change
    create_table :submission_events do |t|
      t.attachment :attachment
      t.text :comment, null: true

      t.timestamps
    end
  end
end
