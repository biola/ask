module ApplicationHelper

  def all_messages
  
    # Standard flash messages
    messages = flash.map{|key,val| {:type=>key, :message=>val} if (!val.blank? && [:warning, :alert, :notice, :success, :error, :info].include?(key)) }.compact
    
    # Model validation errors
    model = instance_variable_get("@#{controller_name.singularize}")
    unless model.nil?
      messages += model.errors.full_messages.map do |msg|
        {:type=>:error, :message=>msg}
      end
    end
    
    messages
    
  end

end
