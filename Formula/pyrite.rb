class Pyrite < Formula
  desc "Pyrite Cloud CLI"
  homepage "https://github.com/PyriteCloud/cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.1/pyrite-aarch64-apple-darwin.tar.xz"
      sha256 "aeed7466d7564f1084c7d23a8ba03809285dd30dfd15e6a9405d05dcdc661aa7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.1/pyrite-x86_64-apple-darwin.tar.xz"
      sha256 "971ddbde0fa60297ca0d6b9e2f0cadc0d45acb73b815ec3443f317ebe084a53f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.1/pyrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d9aa2043276497066653e2daa408163eb7e017e983e02f772053b995ed6b145"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.1/pyrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0739db88e827ed002f118b21ad797c2005180d07b01f964d5376bf318dc00a11"
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
