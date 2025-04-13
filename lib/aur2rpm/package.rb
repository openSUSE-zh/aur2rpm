# frozen_string_literal: true

require 'open3'
require 'fileutils'

class Package
  def initialize(str)
    @name = str
  end

  def fetch
    user_dir = "#{Dir.home}/.aur2rpm/sources/"
    git_url = "https://aur.archlinux.org/#{@name}.git"
    FileUtils.mkdir_p user_dir unless Dir.exist? user_dir

    Open3.popen3("git clone #{git_url}", chdir: user_dir) do |_stdin, _stdout, _stderr, wait_thr|
      puts "Cloning #{git_url}"
      puts wait_thr.value
    end
  end

  def verify; end

  def convert; end

  def build; end

  def install; end
end
