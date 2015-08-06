# -*- coding: utf-8 -*-
class Survey::Question < ActiveRecord::Base
  attr_accessible :text, :title, :typ, :choice_ids, :parent_type, :parent_id
  belongs_to :parent, polymorphic: true
  has_many :choices, dependent: :destroy
  has_many :answers, through: :choices
  include IsCommentable
  FLAG_ICONS={"delete" => "fa fa-trash", "template"=> "ffi1-cleaning1"}
  FLAG_CONFIRM={"delete"=> "Sicher loeschen?"}
  scope :templates, ->{ where(flag_template: true)}
  acts_as_flagable

  def copy_from_template_for(parent)
    unless self.flag_template
      return nil
    else
      cpy = Survey::Question.new(self.attributes_for_copy)
      cpy.parent=parent
      cpy.save
      self.choices.each do |c|
        cpy.choices << c.copy_from_template
      end
    end
  end

  def attributes_for_copy
    self.attributes.select{|k,v| ["title","text","typ"].include?(k)}
  end

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
        if self.typ == 0 
        Survey::Answer.where(user_id: user.id, choice_id: self.choice_ids).delete_all
        end
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
