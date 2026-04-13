class Pyrite < Formula
  desc "Pyrite Cloud CLI"
  homepage "https://github.com/PyriteCloud/cli"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.3/pyrite-aarch64-apple-darwin.tar.xz"
      sha256 "6ae3559d60cce5544ca66f1328cb3676702610ea3f0f7caf7f950f88fd1c20f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.3/pyrite-x86_64-apple-darwin.tar.xz"
      sha256 "916dc9c37108dd2a8be5dfc83826611be52ad6bee0c67beeb50069fa5373ff31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.3/pyrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "93400bc708b46130bc653f3dcd2fcefe14bb9342152c6c858cdaa707c8017741"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.3/pyrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "210817c3557f4921e128a2ecadc75953b9c2baec131d349269df5428cd3453c1"
    end
  end

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
    bin.install "pyrite" if OS.mac? && Hardware::CPU.arm?
    bin.install "pyrite" if OS.mac? && Hardware::CPU.intel?
    bin.install "pyrite" if OS.linux? && Hardware::CPU.arm?
    bin.install "pyrite" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
