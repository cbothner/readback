module ShowsController
  private
  def propagate

  end

  def define_params_method 
    self.class.send :define_method, "#{controller_path.singularize}_params" do
      hash = {}
      hash.merge! params.require(controller_path.singularize).permit(:name, :duration)
    end
  end
end
