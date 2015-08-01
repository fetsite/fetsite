module PluginsHelper
  def divid_for(object,suffix="")
    if object.nil?
      ""
    else
      object.class.to_s.to_lower.gsub("::","_")+ suffix.to_lower + object.id.to_s
    end
  end

end
o
