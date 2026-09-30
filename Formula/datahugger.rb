class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.6.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.7/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "175a07fc8e4a251244c9c29c0b5609e4fef9a082d381e5124120208147dd630f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.7/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "6e7b66b05ea4b6c38043ec08cadd551792ce72d877e63c60c1d6d4e785b332c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.7/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4cc4c8ba202da22f43b9bbfc43efd6360904df58c82bc5ae68fce861f32de6f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.7/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9a875cb7601ddd39968aa59060b58465c4143c3db97f9236f90f2c1d7f85517"
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
