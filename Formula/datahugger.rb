class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.2/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "ce5bb9d98fa960c2a7209721428baa1e7abbc77c0981d9212522f3625a47a567"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.2/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "ebaf20920d8eff4992c1d78dc0f995ffb3a039c576ff27a1aac68d98fdcf417e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.2/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d699b198daee74e4a2087a07b7466e79abe589cb22be96986f25eed34a888fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.2/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e30bc1c64db317d5189679b79635627e8aa7ccb12c9cf88c165029fa68e635f6"
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
