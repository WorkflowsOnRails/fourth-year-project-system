class AddExpiredAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :expired_at, :datetime, index: true
  end
end
