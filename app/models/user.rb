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

  # Use #leave_project, #join_project, and #tasks instead of the
  # following associations. They would be made private, except
  # ActiveRecord will fail if it can't call them.
  belongs_to :project
  has_and_belongs_to_many :projects
  has_many :group_member_tasks, class_name: 'Task',
           through: :project, source: :tasks
  has_many :supervisor_tasks, class_name: 'Task',
           through: :projects, source: :tasks

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

  def join_project(a_project)
    if is_group_member?
      self.project = a_project
    elsif is_supervisor?
      projects << a_project
    end
  end

  def leave_project(a_project)
    if is_group_member?
      self.project = nil
      save!
    elsif is_supervisor?
      projects.delete(a_project)
    end
  end

  def tasks
    if is_group_member?
      group_member_tasks
    elsif is_supervisor?
      supervisor_tasks
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  full_name              :string(255)
#  role                   :string(255)
#  programme              :string(255)
#  student_number         :string(255)
#  project_id             :integer
#  created_at             :datetime
#  updated_at             :datetime
#

