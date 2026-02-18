class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.3.0/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "e9207597452e36542ef1c32ec4ccac620789c83e06985cb822fd6ee9fced656d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.3.0/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "cc8a78c513ed1a86fdb2465a6228d5fa8e4fa7be7952da82610fb5967e5cc50c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.3.0/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f0117f7f8460b4e871b2cc58cbe1370390d6ee2d12f040d190a6d8c4c9e817b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.3.0/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "67dfc7551117dc11ebe37d4f8c0cc2ae17c53972c2d8adcbc52be1100e9a1870"
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
