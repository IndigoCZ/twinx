pdf.number_pages "#{@current_race.title}: #{@document_heading} - <page>/<total>", {
  :at => [(pdf.bounds.width/2)-250, pdf.bounds.bottom - 5],
  :width => 500,
  :align => :right,
  :size => 6
}
