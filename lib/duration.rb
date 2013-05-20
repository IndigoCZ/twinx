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
    "#{min}:#{sec}.#{fract}"
  end
  def min
    return "0" if zero?
    (@ms / 60000).to_s
  end
  def sec
    return "00" if zero?
    ((@ms / 1000) % 60).to_s.rjust(2,"0")
  end
  def fract
    return "000" if zero?
    (@ms % 1000).to_s.rjust(3,"0")
  end

  private
  def zero?
    @ms.nil? || @ms==0
  end

end
