module ApplicationHelper
  def nav_link(link_text, link_path, options={})
    current=false
    ln=link_to_unless_current link_text, link_path do
      current=true
      link_to link_text, link_path, class:"current"
    end
    klass_list=[]
    klass_list<< options[:class] if options[:class]
    klass_list<< "active" if current
    options[:class]=klass_list.join(" ")
    content_tag(:li, ln, options)
  end

  def sort_link(text,attr=nil)
    link_to(text, sort_url(attr), id:"#{attr}_sort", class:"btn btn-default")
  end

  def unsortable(text)
    link_to text, "#", class:"btn btn-default disabled"
  end

  def filter_combo(text,attr)
    new_params=params.dup
    bottom_rows=[]
    if new_params.has_key?(:filter)
      new_params.delete(:filter)
      bottom_rows<<link_to("Nefiltrovat", url_for(new_params))
      bottom_rows<<nil
    end
    attr.to_s.capitalize.safe_constantize.for_race(@current_race).order(:title).each do |model|
      new_params[:filter]="#{attr}_#{model.id}"
      bottom_rows<<link_to(model.title, url_for(new_params))
    end
    render( partial:"controls/dropdown", locals:{dropdown_id:"#{attr}_filter",top_row:sort_link(text,attr),bottom_rows:bottom_rows})
  end

  private

  def sort_url(attr)
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
    url_for(new_params)
  end
end
