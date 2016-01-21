x_pos = ((pdf.bounds.width / 2) - 250)
y_pos = (pdf.bounds.height - 30)
pdf.bounding_box([x_pos, y_pos], :width => 500, :height => 100) do 
  pdf.text @current_race.title, :align => :center, :size => 20
  pdf.float do
    pdf.text @current_race.subtitle, :align => :left, :size => 12
  end
  pdf.float do
    pdf.text I18n.localize(@current_race.held_on).to_s, :align => :right, :size => 12
  end
end
pdf.move_up(30)
pdf.text(@document_heading, :size => 18)
pdf.move_up(30)

