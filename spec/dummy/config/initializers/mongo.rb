ActiveRecord::Base.instance_eval do
  def using_object_ids?
    false
  end
end