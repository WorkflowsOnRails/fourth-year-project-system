# User model shared by Group Members, Supervisors, and Coordinators.
#
# The model is shared to make it easier to interact with devise; instead
# of having two check two controller variables to discover the type of
# the user, we can just query the role. Additionally, the different roles
# share most of their attributes, so it's simpler to just add the role-
# specific attributes to the model, instead of creating and querying a
# one-to-one association for each role type.
#
# @author Brendan MacDonell
class User < ActiveRecord::Base
  GROUP_MEMBER_ROLE = 'group_member'
  SUPERVISOR_ROLE = 'supervisor'
  COORDINATOR_ROLE = 'coordinator'

  ROLES = [GROUP_MEMBER_ROLE, SUPERVISOR_ROLE, COORDINATOR_ROLE]
  PROGRAMMES = ['biomedical', 'communications', 'computer systems',
                'electrical', 'software']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true
  validates :role, inclusion: { in: ROLES }

  with_options if: :is_group_member? do |m|
    m.validates :programme, inclusion: { in: PROGRAMMES }
    m.validates :student_number, uniqueness: true
    m.validates :student_number, format: { with: /\d{9}/,
      message: 'student number must be nine digits' }
  end

  with_options unless: :is_group_member? do |m|
    m.validates :programme, absence: true
    m.validates :student_number, absence: true
    m.validates :project_id, absence: true
  end

  def is_group_member?
    role == GROUP_MEMBER_ROLE
  end

  def is_supervisor?
    role == SUPERVISOR_ROLE or role == COORDINATOR_ROLE
  end

  def is_coordinator?
    role == COORDINATOR_ROLE
  end
end
