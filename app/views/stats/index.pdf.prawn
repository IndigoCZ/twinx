# encoding: UTF-8
prawn_document do |pdf|
  pdf.font("vendor/fonts/DejaVuSans.ttf")
  @document_heading="Statistiky"
  render "layouts/header", :pdf => pdf

  header_list={
    title:'Nej',
    starting_no:'#',
    display_name:'Jméno',
    yob:'Rok nar.',
    born:'Narozen'
  }

  selection={title:{width:160},starting_no:{width:60},display_name:{width:160},yob:{width:60},born:{width:100}}

  data=[]
  @top_participants.each_pair do |tuple, participant|
    gender=(tuple.last==:male ? "Muž" : "Žena")
    age=(tuple.first==:young ? "Nejmladší" : "Nejstarší")
    if participant then
      data<<{
        title:"#{age} #{gender}",
        starting_no:participant.starting_no,
        display_name:participant.person.display_name,
        yob:participant.person.yob,
        born:participant.person.born
      }
    else
      data<<{
        title:"#{age} #{gender}"
      }
    end
  end

  pdf_table_break(pdf)
  pdf.font_size(10)

  pdf.table(pdf_transform_data(header_list,data,selection), :header => true) do
    selection.values.map{ |x| x[:width] }.each_with_index do |val,index|
      column(index).width = val
    end
  end
end

