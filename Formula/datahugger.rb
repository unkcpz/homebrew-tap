class Datahugger < Formula
  desc "Tool for fetching data and metadata from DOI or URL."
  homepage "https://github.com/EOSC-Data-Commons/datahugger-ng"
  version "0.6.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.3/datahugger-aarch64-apple-darwin.tar.xz"
      sha256 "80e0f6d466704738e44e0a2da2aa564e2fe10a6e53cccdca936e7121be6a6d69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.3/datahugger-x86_64-apple-darwin.tar.xz"
      sha256 "f2d206e85f5630935a614ad5af8ad67b966e609b804934927739d75c76988088"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.3/datahugger-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d01cb71264a0ef4acd22af147b9dc42ff34278c643ce25f6940015b4ec701b15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/EOSC-Data-Commons/datahugger-ng/releases/download/v0.6.3/datahugger-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "242013e7af4780a65732b80bafa73dd63aa07c9c0a9ee57acbf00631566aa70a"
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
