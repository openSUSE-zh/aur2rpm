class String
  def strip_colon
    gsub(/"|'/, '')
  end

  def strip_brackets
    gsub(/\(|\)/, '')
  end
end

module AUR2RPM
  class Tag
    class << self
      def respond_to_missing?(tag)
        AUR2RPM::TAGS.include?(tag.to_s) || super
      end

      def method_missing(tag, pkgbuild)
        super unless AUR2RPM::TAGS.include?(tag.to_s)
        # only ^ or \s can be ahead of tag, or optdepends will be recognized to depends
        m = pkgbuild.to_enum(:scan, /(^|\s+)#{tag.to_s}=(((?!^\w).)*)\n/m).map { Regexp.last_match }
        return if m.empty?
        to_tag(m.map(&proc { |i| i[2] }))
      end

      def to_tag(m)
        m.map! do |i|
          if i.start_with?('(')
            sep = i.index(':') ? "\n" : "\s"
            j = i.strip_brackets.split(sep).map(&:strip_colon)
            j.size == 1 ? j[0] : j
          else
            i.strip_colon
          end
        end
      end
    end
  end
end
