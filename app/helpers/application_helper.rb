module ApplicationHelper
  def current_race
    @current_race
  end

  def nav_link(link_text, link_path, options={})
    current=false
    ln=link_to_unless_current link_text, link_path do
      current=true
      link_to link_text, link_path, class:"current"
    end
    klass_list=[]
    klass_list<<"active" if current
    klass_list<<options[:wrapper_class] if options[:wrapper_class]
    content_tag(:li, ln, class:klass_list.join(" "))
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
    content_tag(:ul, class:"nav nav-pills header-pills") do
      content_tag(:li,link_to(text, url_for(new_params), id:"#{attr}_sort"))
    end
  end

  def filter_combo(text,attr)
    content_tag(:ul, id:"#{attr}_filter", class:"nav nav-pills header-pills") do
      content_tag(:li, sort_link(text,attr)) +
      content_tag(:li, class:"dropdown") do
        dropdown_content=link_to '<b class="caret"></b>'.html_safe, "#", class:"dropdown-toggle", data:{toggle:"dropdown"}
        dropdown_content+=content_tag(:ul,:class=>"dropdown-menu") do
          new_params=params.dup
          if new_params.has_key?(:filter)
            new_params.delete(:filter)
            filter_content=content_tag(:li,link_to("Nefiltrovat", url_for(new_params)))
            filter_content+=content_tag(:li,"", class:"divider")
          else
            filter_content=""
          end
          attr.to_s.capitalize.safe_constantize.for_race(@current_race).each do |model|
            new_params[:filter]="#{attr}_#{model.id}"
            filter_content+=content_tag(:li,link_to(model.title, url_for(new_params)))
          end
          filter_content.html_safe
        end
        dropdown_content.html_safe
      end
    end
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
