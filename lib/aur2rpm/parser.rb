require 'nokogiri'
require 'open-uri'

module AUR2RPM
  class Parser
    def initialize(pkg)
      @pkg = pkg
      page = Nokogiri::HTML(open("https://aur.archlinux.org/packages/" + @pkg, "r:UTF-8"))
      @uri = page.xpath('//div[@id="actionlist"]/ul/li/a')[0]["href"].sub!("/tree/","/plain/")
      @pkgbuild = open(@uri, "r:UTF-8").read
    end

    def parse
      pkgbuild = AUR2RPM::PKGBUILD.new(@pkgbuild).parse
    end
  end
end
