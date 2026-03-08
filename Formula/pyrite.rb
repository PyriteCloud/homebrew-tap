class Pyrite < Formula
  desc "Pyrite Cloud CLI"
  homepage "https://github.com/PyriteCloud/cli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.2/pyrite-aarch64-apple-darwin.tar.xz"
      sha256 "b8212b4b8e1ad46420279ba7fb4677db2bc4725af15d51090fac8d3768be0c3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.2/pyrite-x86_64-apple-darwin.tar.xz"
      sha256 "46f7a5975aa8f2aaf54ee3ce9e461d6c9fd6a8508e6f6ccc88524e53b8d44e41"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.2/pyrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d1027c513da54082c783dd1b359b6b7782241e473e32be6e932518ecd515a204"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.1.2/pyrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cca1ea8e8476187ee608da7a3f2d189530a9d479f337d81f67fb0714e02636b3"
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
