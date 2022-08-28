class Average
  @media = 0
  
  def createAverage(numbers) 
    @media = numbers.sum(0.0) / numbers.size
    return @media
  end

  def readAverage()
    return @media
  end
end