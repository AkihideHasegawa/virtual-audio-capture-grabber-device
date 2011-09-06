require 'jruby-swing-helpers/swing_helpers'
# use like ".mp3" "audio=xxx" if desired
ENV['PATH'] = 'ffmpeg\bin;' + ENV['PATH']
include SwingHelpers

seconds = SwingHelpers.get_user_input("Seconds to record for?", 60)
p "doing #{seconds} seconds"
file = JFileChooser.new_nonexisting_filechooser_and_go 'select_file_to_write_to', File.dirname(__FILE__)

file += (ARGV[0] || ".mp4" ) unless file =~ /\./ # add extension for them...

if File.exist? file
  got = JOptionPane.show_select_buttons_prompt "overwrite #{file}?", :yes => "yes", :no => "cancel"
  raise unless got == :yes
  File.delete file
end

#got = JOptionPane.show_select_buttons_prompt 'Select start to start', :yes => "start", :no => "stop"
#raise unless got == :yes
device = ARGV[1] || "video=screen-capture-recorder"
c = "ffmpeg -f dshow -i #{device} -r 20 -t #{seconds} \"#{file}\""
puts c
p c
system c
p 'revealing...'
SwingHelpers.show_in_explorer file
p 'done'