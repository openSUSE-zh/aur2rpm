require 'nokogiri'
require 'open-uri'
require 'ostruct'

module AUR2RPM
  class PKGBUILD
    def initialize(pkg)
      @pkg = pkg
      page = Nokogiri::HTML(open("https://aur.archlinux.org/packages/" + @pkg, "r:UTF-8"))
      @uri = page.xpath('//div[@id="actionlist"]/ul/li/a')[0]["href"].sub!("/tree/","/plain/")
      @pkgbuild = open(@uri, "r:UTF-8").read
      @struct = OpenStruct.new
    end

    def parse
      @struct.preamble = parse_preamble(@pkgbuild)
      PKGBUILD_STAGS.each {|t| @struct[t] = send("parse_" + t, @pkgbuild) }
      @struct
    end

    #private

    def parse_preamble(pkgbuild)
      pkgbuild.match(%r{\A((?!^\s).)*}m)[0]
    end

    PKGBUILD_STAGS.each do |m|
      define_method ("parse_" + m).to_sym do |pkgbuild|
	pkgbuild.match(%r{^#{m}=(.*?)\n}m)[1]
      end
    end
  end
end
