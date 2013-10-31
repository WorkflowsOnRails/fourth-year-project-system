class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :projects_users do |t|
      t.references :user, null: false, index: true
      t.references :project, null: false, index: true
    end

    add_index :projects_users, ['user_id', 'project_id'], unique: true
  end
end
