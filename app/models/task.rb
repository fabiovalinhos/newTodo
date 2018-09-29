class Task < ApplicationRecord
  validates :description, presence: true
  validates :done, inclusion: { in: [true, false] }

  belongs_to :parent, class_name: 'Task', optional: true
  has_many :sub_tasks, class_name: 'Task', foreign_key: :parent_id, dependent: :destroy

  # scope usado no index do controller
  scope :only_parents, -> { where(parent_id: nil)}

  # verificando se uma tarefa é pai e na sequencia vê se subtarefa
  def parent?
    parent_id.nil?
  end

  def sub_tasks?
    # inverso do parent?
    !parent?
  end

  # simbolos e cores na view
  def symbol
    case status
    when 'pending' then '>>'
    when 'done' then '√'
    when 'expired' then 'x'
    end
  end

  def css_color
    case status
    when 'pending' then 'primary'
    when 'done' then 'success'
    when 'expired' then 'danger'
    end
  end

  private

  def status
    return 'done' if done?

    due_date.past? ? 'expired' : 'pending'
  end

end
