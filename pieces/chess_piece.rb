class ChessPiece

  attr_accessor :type
  attr_reader :color

  def initialize(type, color, unicode)
    @type = type
    @color = color
    @unicode = unicode
  end

  def to_s
    "#{@unicode}"
  end


end
