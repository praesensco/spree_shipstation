module SpreeShipstation
  module_function

  # Returns the version of the currently loaded SpreeShipstation as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 3
    MINOR = 3
    TINY  = 0
    PRE   = ''.freeze

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
