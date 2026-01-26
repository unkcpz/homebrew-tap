class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-rs/releases/download/v0.1.0/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "087cee6ec136743cde6311116c5003eeec91839858cf45ef0633fcbef714536c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-rs/releases/download/v0.1.0/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "1957db7180328405081b5995a3d09f61d0d16503b7f1b9302a54f9ca5f8e8413"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-rs/releases/download/v0.1.0/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4defda5f08e2a59121278c89b3e595ba6dcb4b4a023de635daca428b9c77484c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-rs/releases/download/v0.1.0/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bdbc54a4e70a7a7fca3d9a5a20a4db156b2b0e7db27746826c7881003ee6664c"
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
