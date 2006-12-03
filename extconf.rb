#!/usr/bin/env ruby
# = Windows
# === Sample of Makefile creation:
# <tt>ruby extconf.rb --with-opt-dir=c:/Firebird --with-dotnet-dir=C:\PROGRA~1\MICROS~2.NET\Vc7 --with-win32-dir=C:\PROGRA~1\MI9547~1</tt>
# === Notes
# * Windows build currently only compiles using VC7 (Visual Studio .NET 2003).
# * mkmf doesn't like directories with spaces, hence the 8.3 notation in the example above.
# = Linux (Intel)
# === Notes
# * Build seems to "just work."
# * Unit tests take about 10 times as long to complete using Firebird Classic.  Default xinetd.conf settings may not allow the tests to complete due to the frequency with which new attachments are made.
# = Linux (Other)
# * Volunteers?
# = Mac OS X (PowerPC)
# * Coming!
# = Mac OS X (Intel)
# * Volunteers?
require 'mkmf'

libs = %w/ gdslib gds fbclient /  # InterBase library

case RUBY_PLATFORM
  when /bccwin32/
    libs.push "fbclient_bor"
  when /mswin32/
    $CFLAGS  = $CFLAGS + " -DOS_WIN32"
    libs.push "fbclient_ms"
  when /darwin/
    #$CFLAGS  = $CFLAGS + " -DOS_UNIX"
    $CPPFLAGS += " -I/Library/Frameworks/Firebird.framework/Headers"
    $LDFLAGS += " -framework Firebird"
  when /linux/
    $CFLAGS  = $CFLAGS + " -DOS_UNIX"
end

dir_config("firebird")

test_func = "isc_attach_database"

# for ruby-1.8.1 mkmf
case RUBY_PLATFORM
when /mswin32/
  libs.find {|lib| have_library(lib) } and
    have_func(test_func, ["ibase.h"])
else
  libs.find {|lib| have_library(lib, test_func) }
end

create_makefile("fb")
