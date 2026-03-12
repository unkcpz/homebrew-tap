class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.5.0/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "53b0062609e6bcb5d3d47fc22d34121cb4b7e374751b7108a64c3e39ee4dfb3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.5.0/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "ab22d0cd3f4283a85cb2fedad7a15dc7bebae101e3f6e8566ef17fa665fac3c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.5.0/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca2b6f7831e3e0ab2c5c00bf5526c8fe29cf433c18d6d5ddd1033632dff8c5bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.5.0/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e75ea2ec04f1013005832cbd0c1d273d5dfb92f9e3cbe4b7da324b433c01a546"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "datahugger" if OS.mac? && Hardware::CPU.arm?
    bin.install "datahugger" if OS.mac? && Hardware::CPU.intel?
    bin.install "datahugger" if OS.linux? && Hardware::CPU.arm?
    bin.install "datahugger" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
