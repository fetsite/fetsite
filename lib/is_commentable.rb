module IsCommentable
  def self.included(base)
    base.class_eval do
      include InstanceMethods
      has_many :comments, as: :commentable, dependent: :destroy
#      extend ClassMethods

    end
    
  end
  module InstanceMethods  
    def is_commentable?
      true
    end
    def comment(user, text, attr={})
      comments << Comment.build_for(self, user, text, attr)
    end
  end

end
