module ApplicationHelper
  def current_race
    @current_race
  end

  def nav_link(link_text, link_path)
    link_to_unless_current link_text, link_path do
      link_to link_text, link_path, class:"current"
    end
  end

  def sort_link(text,attr=nil)
    new_params=params.dup
    if attr
      if params[:sort] && params[:sort]==attr.to_s
        new_params.delete(:sort)
        new_params[:rsort]=attr
      else
        new_params.delete(:rsort)
        new_params[:sort]=attr
      end
    elsif params[:rsort]=="default"
      new_params.delete(:rsort)
      new_params.delete(:sort)
    else
      new_params[:rsort]="default"
    end
    link_to text, url_for(new_params)
  end

  def display_nonstandard_errors(resource)
    return '' if (resource.errors.empty?)
    if (resource.errors[:base].empty?)
      messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    else
      messages = []
    end
    if resource.nested_attributes_options?
      resource.errors.messages.each_pair do |key,msg|
        resource.nested_attributes_options.each_key do |nest|
          if key.to_s.starts_with?(nest.to_s)
            msg.each do |m|
              nest_model=nest.to_s.singularize.capitalize.constantize
              err_attr=nest_model.human_attribute_name(key.to_s.split(".").last)
              messages<<content_tag(:p, "#{nest_model.model_name.human}: #{err_attr} #{m}")
            end
          end
        end
      end
    end
    return '' if messages.empty?
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
    #{messages}
    </div>
    HTML
    html.html_safe
  end
end
