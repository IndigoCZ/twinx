# encoding: UTF-8
prawn_document do |pdf|
  pdf.font("vendor/fonts/DejaVuSans.ttf")

  header_list={
    name:"Jméno (Číslo)",
    category:"Kategorie",
    team:"Jednota",
    yob:"Rok nar.",
    position:"Umístění",
    time:"Čas"
  }

  if pdf_grouping
    result_groups=@results.to_a.group_by { |result| result.participant.send(pdf_grouping) }
    case pdf_grouping
    when :category
      if result_groups.size > 1
        @document_heading="Kompletní Výsledky"
      else
        @document_heading="Výsledková listina"
      end
      selection={position:{width:70},name:{width:250},team:{width:130},time:{width:80}}
    when :team
      @document_heading="Výsledky jednoty"
      selection={position:{width:70},name:{width:250},category:{width:130},time:{width:80}}
    end
  else
    @document_heading="Přehled výsledků"
    result_groups={all:@results}
    selection={position:{width:50},name:{width:160},team:{width:120},category:{width:120},time:{width:80}}
  end

  render "layouts/header", :pdf => pdf

  result_groups.each_pair do |key,result_list|
    data=[]
    result_list.each do |result|
      data<<{
        name:"#{result.participant.display_name} (#{result.participant.starting_no})",
        category:result.participant.category.title,
        team:result.participant.team.title,
        yob:result.participant.person.yob,
        time:result.time.to_s,
        position:result.position
      }
    end
    if pdf_table_title(key)
      key.dnfs.each do |dnf|
        data<<{
          name:"#{dnf.display_name} (#{dnf.starting_no})",
            category:dnf.category.title,
            team:dnf.team.title,
            yob:dnf.person.yob,
            time:"DNF",
            position:""
        }
      end
    end

    pdf_table_break(pdf)
    if pdf_table_title(key)
      pdf.text(pdf_table_title(key), :size => 16)# Title
    end

    if params[:group]
      pdf.font_size(9)
    else
      pdf.font_size(10)
    end

    pdf.table(pdf_transform_data(header_list,data,selection), :header => true) do
      selection.values.map{ |x| x[:width] }.each_with_index do |val,index|
        column(index).width = val
      end
    end


  end
  render "layouts/page_numbers", :pdf => pdf
end
