class Airplane
  def initialize(status)
    @flying = set(status)
  end

  def flying?
    @flying
  end

  private

  def set(status)
    status == 'flying'
  end
end
