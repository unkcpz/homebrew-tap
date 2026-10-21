class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.6.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.9/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "23ec6ca21e3f0f7248b5e1eda9eab60b8cabe04f89d0789167d562c50f2bd039"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.9/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "88852603bf5793a2ec0bcb15028dcfde2e0a37861c1cfcee7b9d5229248790fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.9/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4cc6834a431fe46848f2e6e055fc63171318d36afe6e0d3440d46e2483c51613"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.9/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a2d67ea6a9c148ad65b19a28c1c06388bb8b2e722c037f2340c1dd097ed7332"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "datahugger"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "datahugger"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "datahugger"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "datahugger"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
