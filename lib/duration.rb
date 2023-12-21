class Duration
  def initialize(ms)
    @ms=ms
  end
  def self.from_ms(ms)
    self.new(ms)
  end
  def self.from_string(string)
    self.from_array(*string.split(/[:,.]/))
  end
  def self.from_hash(hash)
    self.from_array(hash["min"],hash["sec"],hash["fract"])
  end
  def self.from_array(min,sec,msec)
    msec=msec.to_s.ljust(3,"0").to_i
    sec=sec.to_i
    min=min.to_i
    self.new((min*60000)+(sec*1000)+msec)
  end
  def to_i
    return 0 if zero?
    @ms
  end
  def to_s
    return "" if zero?
    "#{min(true)}:#{sec(true)}.#{fract(true)}"
  end
  def min(accuracy_shift=false)
    return "0" if zero?
    if accuracy_shift then
      ((@ms.to_f/100).ceil / 600).to_s
    else
      (@ms / 60000).to_s
    end
  end
  def sec(accuracy_shift=false)
    return "00" if zero?
    if accuracy_shift then
      (((@ms.to_f/100).ceil / 10) % 60).to_s.rjust(2,"0")
    else
      ((@ms / 1000) % 60).to_s.rjust(2,"0")
    end
  end
  def fract(accuracy_shift=false)
    return "000" if zero?
    if accuracy_shift then
      ((@ms.to_f/100).ceil % 10).to_s
    else
      (@ms % 1000).to_s.rjust(3,"0")
    end
  end

  private
  def zero?
    @ms.nil? || @ms==0
  end

end
