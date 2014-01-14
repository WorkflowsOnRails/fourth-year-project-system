class Programme < ActiveRecord::Base

  PROGRAMMES = ['biomedical', 'communications', 'computer systems',
                'electrical', 'software']

  belongs_to :project
  validates :programme, inclusion: { in: PROGRAMMES }

end

# == Schema Information
#
# Table name: programmes
#
#  id         :integer          not null, primary key
#  project_id :integer
#  programme  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
