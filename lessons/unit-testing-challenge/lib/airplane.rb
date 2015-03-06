class Airplane
  attr_reader :type, :wingloading, :horsepower, :running, :flying

  def initialize(type, wingloading, horsepower)
    @type = type
    @wingloading = wingloading
    @horsepower = horsepower
    @running = false
    @flying = false
  end

  def start
    if !running
      @running = true
      'airplane started'
    else
      'airplane already started'
    end
  end

  def takeoff
    if running
      @flying = true
      'airplane launched'
    else
      'airplane not started, please start'
    end
  end

  def land
    if running
      if flying
        @flying = false
        'airplane landed'
      else
        'airplane already on the ground'
      end
    else
      'airplane not started, please start'
    end
  end
end
