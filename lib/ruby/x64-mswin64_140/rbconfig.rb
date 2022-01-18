# encoding: ascii-8bit
# frozen-string-literal: false
#
# The module storing Ruby interpreter configurations on building.
#
# This file was created by mkconfig.rb when ruby was built.  It contains
# build information for ruby which is used e.g. by mkmf to build
# compatible native extensions.  Any changes made to this file will be
# lost the next time ruby is built.

module RbConfig
  RUBY_VERSION.start_with?("3.1.") or
    raise "ruby lib version (3.1.0) doesn't match executable version (#{RUBY_VERSION})"

  # Ruby installed directory.
  TOPDIR = File.dirname(__FILE__).chomp!("/lib/ruby/3.1.0/x64-mswin64_140")
  # DESTDIR on make install.
  DESTDIR = TOPDIR && TOPDIR[/\A[a-z]:/i] || '' unless defined? DESTDIR
  # The hash configurations stored.
  CONFIG = {}
  CONFIG["DESTDIR"] = DESTDIR
  CONFIG["MAJOR"] = "3"
  CONFIG["MINOR"] = "1"
  CONFIG["TEENY"] = "0"
  CONFIG["PATCHLEVEL"] = "0"
  CONFIG["prefix"] = (TOPDIR || DESTDIR + "C:/.conan/.conan/data/ruby/3.1.0/astrabit/testing/package/aee3a365ab177310c562515adebaa1b4c4baf9ae")
  CONFIG["EXEEXT"] = ".exe"
  CONFIG["ruby_install_name"] = "ruby"
  CONFIG["RUBY_INSTALL_NAME"] = "ruby"
  CONFIG["RUBY_SO_NAME"] = "x64-vcruntime140-ruby310"
  CONFIG["SHELL"] = "$(COMSPEC)"
  CONFIG["BUILD_FILE_SEPARATOR"] = "\\"
  CONFIG["PATH_SEPARATOR"] = ";"
  CONFIG["CFLAGS"] = "-MD -Zi -W2 -wd4100 -wd4127 -wd4210 -wd4214 -wd4255 -wd4574  -wd4668 -wd4710 -wd4711 -wd4820 -wd4996  -we4028 -we4142 -we4047 -O2sy- -Zm600 "
  CONFIG["WERRORFLAG"] = "-WX"
  CONFIG["DEFS"] = ""
  CONFIG["CPPFLAGS"] = " -D_WIN32_WINNT=0x0600  "
  CONFIG["CXXFLAGS"] = "-MD -Zi -W2 -wd4100 -wd4127 -wd4210 -wd4214 -wd4255 -wd4574  -wd4668 -wd4710 -wd4711 -wd4820 -wd4996  -we4028 -we4142 -we4047 -O2sy- -Zm600 "
  CONFIG["FFLAGS"] = ""
  CONFIG["LDFLAGS"] = "-incremental:no -debug -opt:ref -opt:icf"
  CONFIG["LIBS"] = "user32.lib"
  CONFIG["MAINLIBS"] = "user32.lib advapi32.lib shell32.lib ws2_32.lib iphlpapi.lib imagehlp.lib shlwapi.lib bcrypt.lib "
  CONFIG["exec_prefix"] = "$(prefix)"
  CONFIG["program_transform_name"] = "s,.*,&,"
  CONFIG["bindir"] = "$(exec_prefix)/bin"
  CONFIG["sbindir"] = "$(exec_prefix)/sbin"
  CONFIG["libexecdir"] = "$(exec_prefix)/libexec"
  CONFIG["datadir"] = "$(prefix)/share"
  CONFIG["sysconfdir"] = ""
  CONFIG["sharedstatedir"] = "$(prefix)/com"
  CONFIG["localstatedir"] = "$(prefix)/var"
  CONFIG["libdir"] = "$(exec_prefix)/lib"
  CONFIG["includedir"] = "$(prefix)/include"
  CONFIG["oldincludedir"] = "/usr/include"
  CONFIG["infodir"] = "$(datadir)/info"
  CONFIG["mandir"] = "$(datadir)/man"
  CONFIG["ridir"] = "$(datadir)/ri"
  CONFIG["docdir"] = "$(datadir)/doc/$(RUBY_BASE_NAME)"
  CONFIG["build"] = "x64-pc-mswin64_140"
  CONFIG["build_alias"] = "x64-mswin64_140"
  CONFIG["build_cpu"] = "x64"
  CONFIG["build_vendor"] = "pc"
  CONFIG["build_os"] = "mswin64_140"
  CONFIG["host"] = "x64-pc-mswin64_140"
  CONFIG["host_alias"] = "x64-mswin64_140"
  CONFIG["host_cpu"] = "x64"
  CONFIG["host_vendor"] = "pc"
  CONFIG["host_os"] = "mswin64_140"
  CONFIG["target"] = "x64-pc-mswin64_140"
  CONFIG["target_alias"] = "x64-mswin64_140"
  CONFIG["target_cpu"] = "x64"
  CONFIG["target_vendor"] = "pc"
  CONFIG["target_os"] = "mswin64_140"
  CONFIG["NULLCMD"] = ":"
  CONFIG["CC"] = "cl -nologo"
  CONFIG["CPP"] = "cl -nologo -E"
  CONFIG["CXX"] = "$(CC)"
  CONFIG["LD"] = "$(CC)"
  CONFIG["YACC"] = "bison"
  CONFIG["RANLIB"] = ""
  CONFIG["AR"] = "lib -nologo"
  CONFIG["ARFLAGS"] = "-machine:x64 -out:"
  CONFIG["LN_S"] = ""
  CONFIG["SET_MAKE"] = "MFLAGS = -$(MAKEFLAGS)"
  CONFIG["RM"] = "$(COMSPEC) /C $(top_srcdir:/=\\)\\win32\\rm.bat"
  CONFIG["RMDIR"] = "$(COMSPEC) /C $(top_srcdir:/=\\)\\win32\\rmdirs.bat"
  CONFIG["RMDIRS"] = "$(COMSPEC) /C $(top_srcdir:/=\\)\\win32\\rmdirs.bat"
  CONFIG["RMALL"] = "$(COMSPEC) /C $(top_srcdir:/=\\)\\win32\\rm.bat -f -r"
  CONFIG["MAKEDIRS"] = "$(COMSPEC) /E:ON /C $(top_srcdir:/=\\)\\win32\\makedirs.bat"
  CONFIG["ALLOCA"] = ""
  CONFIG["EXECUTABLE_EXTS"] = ".exe .com .cmd .bat"
  CONFIG["OBJEXT"] = "obj"
  CONFIG["ASMEXT"] = "asm"
  CONFIG["DLDFLAGS"] = "-incremental:no -debug -opt:ref -opt:icf -dll $(LIBPATH)"
  CONFIG["EXTDLDFLAGS"] = ""
  CONFIG["ARCH_FLAG"] = ""
  CONFIG["STATIC"] = ""
  CONFIG["CCDLFLAGS"] = ""
  CONFIG["LDSHARED"] = "cl -nologo -LD"
  CONFIG["SOEXT"] = "dll"
  CONFIG["DLEXT"] = "so"
  CONFIG["LIBEXT"] = "lib"
  CONFIG["STRIP"] = ""
  CONFIG["ENCSTATIC"] = ""
  CONFIG["EXTSTATIC"] = ""
  CONFIG["setup"] = "Setup"
  CONFIG["PREP"] = "miniruby.exe"
  CONFIG["EXTOUT"] = ".ext"
  CONFIG["ARCHFILE"] = ""
  CONFIG["RUBY_BASE_NAME"] = "ruby"
  CONFIG["rubyw_install_name"] = "rubyw"
  CONFIG["RUBYW_INSTALL_NAME"] = "rubyw"
  CONFIG["LIBRUBY_A"] = "$(RUBY_SO_NAME)-static.lib"
  CONFIG["LIBRUBY_SO"] = "$(RUBY_SO_NAME).dll"
  CONFIG["LIBRUBY_ALIASES"] = ""
  CONFIG["LIBRUBY"] = "$(RUBY_SO_NAME).lib"
  CONFIG["LIBRUBYARG"] = "$(LIBRUBYARG_SHARED)"
  CONFIG["LIBRUBYARG_STATIC"] = "$(LIBRUBY_A) $(MAINLIBS)"
  CONFIG["LIBRUBYARG_SHARED"] = "$(LIBRUBY)"
  CONFIG["SOLIBS"] = ""
  CONFIG["DLDLIBS"] = ""
  CONFIG["ENABLE_SHARED"] = "yes"
  CONFIG["OUTFLAG"] = "-Fe"
  CONFIG["COUTFLAG"] = "-Fo"
  CONFIG["CSRCFLAG"] = "-Tc"
  CONFIG["CPPOUTFILE"] = "-P"
  CONFIG["PRELOADENV"] = ""
  CONFIG["LIBPATHENV"] = "PATH"
  CONFIG["LIBPATHFLAG"] = " -libpath:%s"
  CONFIG["RPATHFLAG"] = ""
  CONFIG["LIBARG"] = "%s.lib"
  CONFIG["LINK_SO"] = "$(LDSHARED) -Fe$(@) $(OBJS) $(LIBS) $(LOCAL_LIBS) -link $(DLDFLAGS) -implib:$(*F:.so=)-$(arch).lib -pdb:$(*F:.so=)-$(arch).pdb -def:$(DEFFILE)"
  CONFIG["LINK_SO"] << "\n" "@if exist $(@).manifest $(RUBY) -run -e wait_writable -- -n 10 $(@)"
  CONFIG["LINK_SO"] << "\n" "@if exist $(@).manifest mt -nologo -manifest $(@).manifest -outputresource:$(@);2"
  CONFIG["LINK_SO"] << "\n" "@if exist $(@).manifest $(RM) $(@:/=\\).manifest"
  CONFIG["COMPILE_C"] = "$(CC) $(INCFLAGS) $(CFLAGS) $(CPPFLAGS) $(COUTFLAG)$(@) -c $(CSRCFLAG)$(<:\\=/)"
  CONFIG["COMPILE_CXX"] = "$(CXX) $(INCFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(COUTFLAG)$(@) -c -Tp$(<:\\=/)"
  CONFIG["ASSEMBLE_C"] = "$(CC) $(CFLAGS) $(CPPFLAGS) -Fa$(@) -c $(CSRCFLAG)$(<:\\=/)"
  CONFIG["ASSEMBLE_CXX"] = "$(CXX) $(CXXFLAGS) $(CPPFLAGS) -Fa$(@) -c -Tp$(<:\\=/)"
  CONFIG["COMPILE_RULES"] = "{$(*VPATH*)}.%s.%s: .%s.%s:"
  CONFIG["CXX_EXT"] = "cpp"
  CONFIG["RULE_SUBST"] = "{.;$(VPATH)}%s"
  CONFIG["TRY_LINK"] = "$(CC) -Feconftest $(INCFLAGS) -I$(hdrdir) $(CPPFLAGS) $(CFLAGS) $(src) $(LOCAL_LIBS) $(LIBS) -link $(LDFLAGS) $(LIBPATH) $(XLDFLAGS)"
  CONFIG["COMMON_LIBS"] = "m"
  CONFIG["COMMON_MACROS"] = "WIN32_LEAN_AND_MEAN WIN32"
  CONFIG["COMMON_HEADERS"] = "winsock2.h ws2tcpip.h windows.h"
  CONFIG["cleanobjs"] = "$*.exp $*.lib $*.pdb"
  CONFIG["DISTCLEANFILES"] = "vc*.pdb"
  CONFIG["EXPORT_PREFIX"] = " "
  CONFIG["archlibdir"] = "$(libdir)/$(arch)"
  CONFIG["sitearchlibdir"] = "$(libdir)/$(sitearch)"
  CONFIG["archincludedir"] = "$(includedir)/$(arch)"
  CONFIG["sitearchincludedir"] = "$(includedir)/$(sitearch)"
  CONFIG["arch"] = "x64-mswin64_140"
  CONFIG["sitearch"] = "x64-vcruntime140"
  CONFIG["ruby_version"] = "3.1.0"
  CONFIG["RUBY_PROGRAM_VERSION"] = "$(MAJOR).$(MINOR).$(TEENY)"
  CONFIG["RUBY_API_VERSION"] = "$(MAJOR).$(MINOR)"
  CONFIG["rubylibprefix"] = "$(prefix)/lib/$(RUBY_BASE_NAME)"
  CONFIG["rubyarchdir"] = "$(rubylibdir)/$(arch)"
  CONFIG["rubylibdir"] = "$(rubylibprefix)/$(ruby_version)"
  CONFIG["sitedir"] = "$(rubylibprefix)/site_ruby"
  CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
  CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
  CONFIG["vendordir"] = "$(rubylibprefix)/vendor_ruby"
  CONFIG["vendorarchdir"] = "$(vendorlibdir)/$(sitearch)"
  CONFIG["vendorlibdir"] = "$(vendordir)/$(ruby_version)"
  CONFIG["rubyhdrdir"] = "$(includedir)/$(RUBY_BASE_NAME)-$(ruby_version)"
  CONFIG["sitehdrdir"] = "$(rubyhdrdir)/site_ruby"
  CONFIG["vendorhdrdir"] = "$(rubyhdrdir)/vendor_ruby"
  CONFIG["rubyarchhdrdir"] = "$(rubyhdrdir)/$(arch)"
  CONFIG["sitearchhdrdir"] = "$(sitehdrdir)/$(sitearch)"
  CONFIG["vendorarchhdrdir"] = "$(vendorhdrdir)/$(sitearch)"
  CONFIG["PLATFORM_DIR"] = "win32"
  CONFIG["THREAD_MODEL"] = "win32"
  CONFIG["configure_args"] = "--with-make-prog=nmake --enable-shared --prefix=C:\\.conan\\.conan\\data\\ruby\\3.1.0\\astrabit\\testing\\package\\aee3a365ab177310c562515adebaa1b4c4baf9ae --target=x64-mswin64 --without-ext=\"dbm,gdbm,pty,readline,syslog,\" --disable-install-doc"
  CONFIG["try_header"] = "try_compile"
  CONFIG["ruby_pc"] = "ruby-3.1.pc"
  CONFIG["MJIT_SUPPORT"] = "yes"
  CONFIG["UNICODE_VERSION"] = "13.0.0"
  CONFIG["UNICODE_EMOJI_VERSION"] = "13.1"
  CONFIG["platform"] = "$(arch)"
  CONFIG["archdir"] = "$(rubyarchdir)"
  CONFIG["topdir"] = File.dirname(__FILE__)
  # Almost same with CONFIG. MAKEFILE_CONFIG has other variable
  # reference like below.
  #
  #   MAKEFILE_CONFIG["bindir"] = "$(exec_prefix)/bin"
  #
  # The values of this constant is used for creating Makefile.
  #
  #   require 'rbconfig'
  #
  #   print <<-END_OF_MAKEFILE
  #   prefix = #{RbConfig::MAKEFILE_CONFIG['prefix']}
  #   exec_prefix = #{RbConfig::MAKEFILE_CONFIG['exec_prefix']}
  #   bindir = #{RbConfig::MAKEFILE_CONFIG['bindir']}
  #   END_OF_MAKEFILE
  #
  #   => prefix = /usr/local
  #      exec_prefix = $(prefix)
  #      bindir = $(exec_prefix)/bin  MAKEFILE_CONFIG = {}
  #
  # RbConfig.expand is used for resolving references like above in rbconfig.
  #
  #   require 'rbconfig'
  #   p RbConfig.expand(RbConfig::MAKEFILE_CONFIG["bindir"])
  #   # => "/usr/local/bin"
  MAKEFILE_CONFIG = {}
  CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}

  # call-seq:
  #
  #   RbConfig.expand(val)         -> string
  #   RbConfig.expand(val, config) -> string
  #
  # expands variable with given +val+ value.
  #
  #   RbConfig.expand("$(bindir)") # => /home/foobar/all-ruby/ruby19x/bin
  def RbConfig::expand(val, config = CONFIG)
    newval = val.gsub(/\$\$|\$\(([^()]+)\)|\$\{([^{}]+)\}/) {
      var = $&
      if !(v = $1 || $2)
	'$'
      elsif key = config[v = v[/\A[^:]+(?=(?::(.*?)=(.*))?\z)/]]
	pat, sub = $1, $2
	config[v] = false
	config[v] = RbConfig::expand(key, config)
	key = key.gsub(/#{Regexp.quote(pat)}(?=\s|\z)/n) {sub} if pat
	key
      else
	var
      end
    }
    val.replace(newval) unless newval == val
    val
  end
  CONFIG.each_value do |val|
    RbConfig::expand(val)
  end

  # :nodoc:
  # call-seq:
  #
  #   RbConfig.fire_update!(key, val)               -> array
  #   RbConfig.fire_update!(key, val, mkconf, conf) -> array
  #
  # updates +key+ in +mkconf+ with +val+, and all values depending on
  # the +key+ in +mkconf+.
  #
  #   RbConfig::MAKEFILE_CONFIG.values_at("CC", "LDSHARED") # => ["gcc", "$(CC) -shared"]
  #   RbConfig::CONFIG.values_at("CC", "LDSHARED")          # => ["gcc", "gcc -shared"]
  #   RbConfig.fire_update!("CC", "gcc-8")                  # => ["CC", "LDSHARED"]
  #   RbConfig::MAKEFILE_CONFIG.values_at("CC", "LDSHARED") # => ["gcc-8", "$(CC) -shared"]
  #   RbConfig::CONFIG.values_at("CC", "LDSHARED")          # => ["gcc-8", "gcc-8 -shared"]
  #
  # returns updated keys list, or +nil+ if nothing changed.
  def RbConfig.fire_update!(key, val, mkconf = MAKEFILE_CONFIG, conf = CONFIG)
    return if mkconf[key] == val
    mkconf[key] = val
    keys = [key]
    deps = []
    begin
      re = Regexp.new("\\$\\((?:%1$s)\\)|\\$\\{(?:%1$s)\\}" % keys.join('|'))
      deps |= keys
      keys.clear
      mkconf.each {|k,v| keys << k if re =~ v}
    end until keys.empty?
    deps.each {|k| conf[k] = mkconf[k].dup}
    deps.each {|k| expand(conf[k])}
    deps
  end

  # call-seq:
  #
  #   RbConfig.ruby -> path
  #
  # returns the absolute pathname of the ruby command.
  def RbConfig.ruby
    File.join(
      RbConfig::CONFIG["bindir"],
      RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]
    )
  end
end
CROSS_COMPILING = nil unless defined? CROSS_COMPILING
