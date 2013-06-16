module DefaultControllerActions
  def default_update(klass)
    klass_sym=klass.to_s.downcase.to_sym
    define_method(:update) do
      instance_variable_set("@#{klass_sym}",klass.find(params[:id]))
      if instance_variable_get("@#{klass_sym}").update_attributes(self.send("#{klass_sym}_params"))
        redirect_to [instance_variable_get("@current_race"),instance_variable_get("@#{klass_sym}")], notice: t("messages.#{klass_sym}.updated_successfully")
      else
        render action: "edit"
      end
    end
  end
end
