module AUR2RPM
  class PKGBUILD
    def initialize(text)
      @text = text
      @pkgbuild = OpenStruct.new
    end

    def parse
      AUR2RPM::TAGS.each do |t|
        tag = AUR2RPM::Tag.send(t.to_sym, @text)
        @pkgbuild[t] = tag unless tag.nil?
      end
      @pkgbuild
    end
  end
end
