# encoding: utf-8

class WWPassException < StandardError
  
  def initialize(message, reason = ' ')
    super message + reason
  end
  
end