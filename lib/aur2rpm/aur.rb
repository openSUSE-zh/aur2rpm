# frozen_string_literal: true

require 'net/http'

module ArchUserRepo
  def exist?(package)
    Net::HTTP.get_response(URI("https://aur.archlinux.org/packages/#{package}")).code == '404'
  end
end
