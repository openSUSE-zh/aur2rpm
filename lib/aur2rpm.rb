dir = File.basename(__FILE__).sub('.rb', '')
path = File.join(File.dirname(File.expand_path(__FILE__)), dir)
Dir.glob(path + '/*').each do |i|
  require dir + '/' + File.basename(i) if File.basename(i) =~ /\.rb/
end
require 'ostruct'
