# encoding: UTF-8
prawn_document do |pdf|
  pdf.font("vendor/fonts/DejaVuSans.ttf")
  render "layouts/header", :pdf => pdf

  header_list={
    title:"Jednota",
    points:"Body",
    participants:"Počet Účastníků"
  }

  selection={title:{width:160},points:{width:130},participants:{width:130}}

  data=[]
  @teams.each do |team|
    data<<{
      title:team.title,
      points:team.points(params[:limit]),
      participants:team.participants.count
    }
  end

  pdf_table_break(pdf)
  pdf.text("Pohár Jednot", :size => 16)# Title
  pdf.font_size(10)

  pdf.table(pdf_transform_data(header_list,data,selection), :header => true) do
    selection.values.map{ |x| x[:width] }.each_with_index do |val,index|
      column(index).width = val
    end
  end
end
