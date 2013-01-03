# encoding: UTF-8
prawn_document( :page_size => 'A4', :page_layout => :portrait, :margin => 25) do |pdf|
  pdf.font("#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf")
  render "layouts/header", :pdf => pdf

  header_list={
    starting_no:{title:"#",width:70},
    name:{title:"Jméno",width:250},
    category:{title:"Kategorie",width:70},
    team:{title:"Jednota",width:130}
  }

  selection=[:starting_no,:name,:category,:team]
  if pdf_grouping
    participant_groups=@participants.to_a.group_by(& pdf_grouping)
    selection.delete(pdf_grouping)
  else
    participant_groups={all:@participants}
  end

  participant_groups.each_pair do |key,participant_list|
    data=[]
    participant_list.each do |participant|
      data<<{
        starting_no:participant.starting_no,
        name:participant.display_name,
        category:participant.category.title,
        team:participant.team.title
      }
    end

    pdf_table_break(pdf)
    if pdf_table_title(key)
      pdf.text pdf_table_title(key), :size => 16 # Title
    end

    pdf.font_size(10)
    column_widths=pdf_column_widths(header_list,selection)
    pdf.table(pdf_transform_data(header_list,data,selection), :header => true) do
      column_widths.each_with_index do |val,index|
        column(index).width = val
      end
    end
  end
end
