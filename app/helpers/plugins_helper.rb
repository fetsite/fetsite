module PluginsHelper
  def divid_for(obj,suffix="")
    if obj.nil?
      ""
    else
      obj.class.to_s.downcase.gsub("::","_")+ "_" + suffix.downcase + "_" + obj.id.to_s
    end
  end
  def div_tag_for(o,&block)
    content = capture(&block)
    content_tag(:div, content, :id=>divid_for(o))
  end
end

