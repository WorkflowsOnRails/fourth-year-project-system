class ChangeDeadlineInTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :deadline, :datetime
    add_column :tasks, :deadline_id, :string
  end
end
