class Comment < ActiveRecord::Base
  attr_accessible :text,:anonym, :intern, :hidden
  # commentable depth, official, intern, anonym
  acts_as_votable
  acts_as_nested_set  :scope => [:commentable_id, :commentable_type]
  belongs_to :commentable, :polymorphic=> true
  belongs_to :user
  validate :text, :presence=>true
  validate :user, :presence=>true
  validate :commentable, :presence=>true
  include IsCommentable

  def self.build_for(set_commentable, user, text,attr={})
    c = new
    raise "Tried to build comment for non commentable" unless set_commentable.try(:is_commentable?)
      c.user=user
      c.text=text
      c.assign_attributes(attr)
    
    unless set_commentable.class.to_s == "Comment"
      c.commentable=set_commentable
      c.save    
    else
      
      c.commentable=set_commentable.commentable
      c.save
      c.move_to_child_of(set_commentable)
    end
    c
  end
  def thumb_url
    t_url= user.fetprofile.picture.thumb.url unless user.nil? or user.fetprofile.nil?
    t_url
  end
  def self.wrapid_for(c)
    "comments_" + c.class.to_s.gsub(":","_") + "_" + c.id.to_s
  end

  def self.switchshowid_for(c)
    "show_comments_" + c.class.to_s.gsub(":","_") + "_" + c.id.to_s
  end
  def divid
    "comment_" + id.to_s
  end
  def formid
"comment_form_" + commentable_type.gsub(":","_") + "_" + commentable_id.to_s 
  end
  def self.formid_for(c)
    "comment_form_" + c.class.to_s.gsub(":","_") + "_" + c.id.to_s 
    end
end
