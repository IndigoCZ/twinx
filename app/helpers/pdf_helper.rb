module PdfHelper
  def pdf_table_break(pdf)
    if pdf.cursor < 120
      pdf.start_new_page
    else
      pdf.move_down(50)
    end
  end

  def pdf_grouping
    if params[:filter]
      filter_by=params[:filter].split("_").first
      case filter_by
      when "category"
        :category
      when "team"
        :team
      else
        raise "Unknown filter type"
      end
    elsif params[:group]
      case params[:group]
      when "category"
        :category
      when "team"
        :team
      else
        nil
      end
    else
      nil
    end
  end

  def pdf_transform_data(header_list,data,selection)
    rval=[]
    row=[]
    selection.each do |col|
      row<<header_list[col][:title]
    end
    rval<<row

    data.each do |line|
      row=[]
      selection.each do |col|
        row<<line[col]
      end
      rval<<row
    end
    rval
  end

  def pdf_column_widths(header_list,selection)
    rval=[]
    selection.each do |col|
      rval<<header_list[col][:width]
    end
    rval
  end

  def pdf_table_title(key)
    case key
    when Team
      key.title
    when Category
      key.title
    else
      nil
    end
  end
end
