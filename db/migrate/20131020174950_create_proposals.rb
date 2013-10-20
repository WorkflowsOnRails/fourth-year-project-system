class CreateProposals < ActiveRecord::Migration
  def self.up
    create_table :proposals do |t|
      t.string :aasm_state
    end
  end

  def self.down
    drop_table :proposals
  end
end
