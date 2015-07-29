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
end

