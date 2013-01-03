# encoding: UTF-8
prawn_document( :page_size => 'A4', :page_layout => :portrait, :margin => 25) do |pdf|
  pdf.font("#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf")
  render "layouts/header", :pdf => pdf

  header_list={
    name:"Jméno (#)",
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
      selection={position:{width:70},name:{width:250},team:{width:130},time:{width:80}}
    when :team
      selection={position:{width:70},name:{width:250},category:{width:130},time:{width:80}}
    end
  else
    result_groups={all:@results}
    selection={position:{width:50},name:{width:200},team:{width:100},category:{width:100},time:{width:80}}
  end

  result_groups.each_pair do |key,result_list|
    data=[]
    result_list.each do |result|
      data<<{
        name:"#{result.participant.display_name} (#{result.participant.starting_no})",
        category:result.participant.category.title,
        team:result.participant.team.title,
        yob:result.participant.person.yob,
        time:result.time,
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

    pdf.font_size(10)

    pdf.table(pdf_transform_data(header_list,data,selection), :header => true) do
      selection.values.map{ |x| x[:width] }.each_with_index do |val,index|
        column(index).width = val
      end
    end
  end
end
