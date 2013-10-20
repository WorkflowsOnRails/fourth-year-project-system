class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project, index: true

      t.string :taskable_type
      t.integer :taskable_id

      t.string :summary
      t.datetime :deadline
      t.datetime :completed_at, index: true
    end
  end
end
