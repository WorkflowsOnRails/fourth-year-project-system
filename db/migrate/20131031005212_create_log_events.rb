class CreateLogEvents < ActiveRecord::Migration
  def change
    create_table :log_events do |t|
      t.references :user, null: false, index: true
      t.references :task, null: false, index: true
      t.references :details, polymorphic: true, null: false, index: true

      t.datetime :created_at, index: true
    end
  end
end
