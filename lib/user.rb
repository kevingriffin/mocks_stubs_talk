class User
  def initialize
    @premium_access = false
  end

  def premium?
    !!@premium_access
  end

  def paid!
    @premium_access = true
  end

  def canceled!
    @premium_access = false
  end
end
