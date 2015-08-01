module CommentsHelper
  def wrapid_for(o)
    divid_for(o,"comments")
  end
  def render_comments_for(o)
    render partial: "comments/comments_block", object: o
  end
end
