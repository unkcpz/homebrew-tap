class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.6.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.8/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "6c40fae8b70c129c21e257f70a1f98f195613642235d3717908f9aa9be44e8c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.8/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "9a572cd134d1490349912d73495220b9fc6a5eb64c0a902d2c05b7fa1889d75f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.8/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d2386ffe1d1ab15e3938d47c7a8ca9ca199897723d47e9daba42b575b8716c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.8/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81184b683dd2423d816545392060c76c4bb80a8ee66052ab0a054e989c50ca13"
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
