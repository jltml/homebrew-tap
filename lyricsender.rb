class Lyricsender < Formula
  desc "Send lyrics, line-by-line, using iMessage"
  homepage "https://github.com/jltml/lyricsender"
  url "https://github.com/jltml/lyricsender/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d4cdd3ac32f864088f145d92ebb552b6af90ad78729eebccf83656efd1d60748"
  license "MIT"
  revision 1

  depends_on :macos
  depends_on "ruby"
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "-V", "#{name}-#{version}.gem", "--no-document", "--platform=ruby", "--", "--use-system-libraries"
    system "gem", "pristine", "-V", "--all"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  def caveats
    <<~EOS
      A quick note: if you get weird things like "Ignoring nokogiri-1.11.7
      because its extensions are not built", try building from source:
        `brew install lyricsender --build-from-source`.
    EOS
  end

  test do
    assert_equal "lyricsender v#{version}", shell_output("#{bin}/lyricsender --version").strip
  end
end
