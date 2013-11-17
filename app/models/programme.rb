class Programme < ActiveRecord::Base

  PROGRAMMES = ['biomedical', 'communications', 'computer systems',
                'electrical', 'software']

  belongs_to :project
  validates :programme, inclusion: { in: PROGRAMMES }

end
