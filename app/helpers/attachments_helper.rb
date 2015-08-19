module AttachmentsHelper

  def render_attachments_for(p)
    a= Attachment.new 
    a.parent=p
    render(partial:"attachments/attachment_list", object: p.attachments, locals: {editor: (can?(:edit, p)), parent: p} )+ ((can?(:edit, p))? (render partial:"attachments/form_bulk2", object: a ): "")
    
  end

  def render_attachments_list_for(p)
    a= Attachment.new 
    a.parent=p
    render(partial:"attachments/attachment_list", object: p.attachments, locals: {editor: (can?(:edit, p)), parent: p} )
  end

  def render_new_attachments_for(p, text, options={})
    a= Attachment.new 
    a.parent=p
    ((can?(:edit, p))? (render partial:"attachments/form_bulk2", object: a ): "")+ link_to(text, new_calentry_path(),options)
  end
end
