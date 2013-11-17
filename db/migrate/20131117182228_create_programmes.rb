class CreateProgrammes < ActiveRecord::Migration
  def change
    create_table :programmes do |t|
      t.references :project
      t.string :programme
      t.timestamps
    end
  end
end
