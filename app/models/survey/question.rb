class Survey::Question < ActiveRecord::Base
  attr_accessible :text, :title, :typ, :choice_ids
  belongs_to :parent, polymorphic: true
  has_many :choices
  has_many :answers, through: :choices
  include IsCommentable

  def add_yesno_choices
    c=Survey::Choice.new(title: "Ja")
    c.save
    this.choices << c
    c=Survey::Choice.new(title: "Nein")
    c.save
    this.choices << c
  end

  def do_answer(choice_ids, user)
    unless (user.nil? || choice_ids.nil? || choice_ids.empty?)
      cid=choice_ids.map{|c|c.to_i}
      if (Survey::Answer.where(user_id: user.id, choice_id: cid).count > 0 )
        found_ids=Survey::Answer.where(user_id: user.id, choice_id: cid).includes(:choice).pluck(:choice_id)
        cid= cid - found_ids
        Survey::Answer.where(user_id: user.id, choice_id: found_ids).delete_all
      else
        Survey::Answer.where(user_id: user.id, choice_id: self.choice_ids).delete_all
      end
      cid.each do |c|
        if self.choice_ids.include?(c)
          a=Survey::Answer.new(user_id: user.id, choice_id: c.to_i)
          a.save
        end
      end
    end
  end
end
