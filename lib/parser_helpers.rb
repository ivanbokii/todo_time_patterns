class String
  def letter?
    ('a'..'z').include?(self) or ('A'..'Z').include?(self)
  end

  def number?
    true if Integer(self) rescue false
  end

  def symbol?
    [':', '#'].include?(self)
  end

  def unknown?
    not letter? and not number?
  end
end