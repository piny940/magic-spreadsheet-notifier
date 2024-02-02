class Recruit
  attr_accessor :title, :recruit_start_date, :recruit_end_date, :technologies, :link, :kind, :company, :area, :reward, :schedule1, :schedule2, :schedule3, :comment

  def initialize(**params)
    params.each{ |k, v| send("#{k}=", v) if self.methods.include?(k) }
  end

  def to_h
    self.instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@')] = self.instance_variable_get(var)
    end
  end
end
