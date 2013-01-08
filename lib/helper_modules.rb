module TokensStringRepresentation
  def to_s
    self.each_with_object("") { |token, result| result << token.to_s }  
  end
end