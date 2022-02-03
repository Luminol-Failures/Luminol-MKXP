require "rbconfig"

module OS
  def self.os
    case RbConfig::CONFIG["host_os"]
    when /mswin|windows/i
      return "windows"
    when /linux|arch/i
      return "linux"
    when /sunos|solaris/i
      raise "Solaris is not supported"
    when /darwin/i
      raise "Mac OS X is not supported"
    else
      raise "Unknown OS: #{Config::CONFIG["host_os"]}, please report this error to the developer."
    end
  end
end
