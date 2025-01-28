class Rsdos < Formula
  desc "key-value store for file I/O on disk"
  homepage "https://github.com/unkcpz/rsdos"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/unkcpz/rsdos/releases/download/v0.2.0/rsdos-aarch64-apple-darwin.tar.xz"
      sha256 "551b73b719f5afdfee577c7dff25a18639f76b75712073a1c5e039d5819bc282"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unkcpz/rsdos/releases/download/v0.2.0/rsdos-x86_64-apple-darwin.tar.xz"
      sha256 "4ccd402eddefc8bf1aec62d4ec017978efc773e434cac8fd799e55855c56fca6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/unkcpz/rsdos/releases/download/v0.2.0/rsdos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "23b91032c7cf91db6de27003ba909c63b29e3a3a40b745f8f7df0b341ca66f17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/unkcpz/rsdos/releases/download/v0.2.0/rsdos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa4e3b4d91e3aacebc438a1b5a7cab2a992f066e51efc9515fb18f622f828d0e"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "rsdos" if OS.mac? && Hardware::CPU.arm?
    bin.install "rsdos" if OS.mac? && Hardware::CPU.intel?
    bin.install "rsdos" if OS.linux? && Hardware::CPU.arm?
    bin.install "rsdos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
