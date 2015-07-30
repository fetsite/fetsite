class Survey::Question < ActiveRecord::Base
  attr_accessible :text, :title, :typ, :choice_ids
  belongs_to :parent, polymorphic: true
  has_many :choices
  has_many :answers, through: :choices
  def add_yesno_choices
    c=Survey::Choice.new(title: "Ja")
    c.save
    this.choices << c
    c=Survey::Choice.new(title: "Nein")
    c.save
    this.choices << c
  end

  def do_answer(choice_ids, user)
    cid=choice_ids.map{|c|c.to_i}
    Survey::Answer.where(user_id: user.id, choice_id: self.choice_ids).delete_all
    cid.each do |c|
      if self.choice_ids.include?(c)
      a=Survey::Answer.new(user_id: user.id, choice_id: c.to_i)
      a.save
      end
    end
  end
end

