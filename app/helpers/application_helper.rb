module ApplicationHelper
  def nav_link(link_text, link_path, options={})
    current=false
    ln=link_to_unless_current link_text, link_path do
      current=true
      link_to link_text, link_path, class:"current"
    end
    klass_list=[]
    klass_list<<"active" if current
    klass_list<<options[:wrapper_class] if options[:wrapper_class]
    content_tag(:li, ln, :class => klass_list.join(" "))
  end

  def sort_link(text,attr=nil)
    content_tag(:ul, :class =>"nav nav-pills header-pills") do
      content_tag(:li,actual_sort_link(text,attr))
    end
  end

  def actual_sort_link(text,attr)
    new_params=params.dup
    attr||="default"
    attr=attr.to_s
    if @navigator.reverse_sort || @navigator.sort_by!=attr
      new_params.delete(:rsort)
      new_params[:sort]=attr
    else
      new_params.delete(:sort)
      new_params[:rsort]=attr
    end
    new_params.delete(:sort) if new_params[:sort]=="default"
    link_to(text, url_for(new_params), id:"#{attr}_sort")
  end

  def filter_combo(text,attr)
    new_params=params.dup
    bottom_rows=[]
    if new_params.has_key?(:filter)
      new_params.delete(:filter)
      bottom_rows<<link_to("Nefiltrovat", url_for(new_params))
      bottom_rows<<nil
    end
    attr.to_s.capitalize.safe_constantize.for_race(@current_race).each do |model|
      new_params[:filter]="#{attr}_#{model.id}"
      bottom_rows<<link_to(model.title, url_for(new_params))
    end
    render( partial:"controls/dropdown", locals:{dropdown_id:"#{attr}_filter",top_row:actual_sort_link(text,attr),bottom_rows:bottom_rows})
  end
end
