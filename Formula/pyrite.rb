class Pyrite < Formula
  desc "Pyrite Cloud CLI"
  homepage "https://github.com/PyriteCloud/cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.2.0/pyrite-aarch64-apple-darwin.tar.xz"
      sha256 "57ba99a036d6e6dcf2c68dfa4584bccfe0cdf1d758d15a7645fa47bc296fe223"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.2.0/pyrite-x86_64-apple-darwin.tar.xz"
      sha256 "da2429ba0f8798a1d8bf560b71fa9768047547bab71ca247adfaa0d550178cda"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.2.0/pyrite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa129ba940a3157864eef45157663229e657c4ad3309648f924b20dee197bd21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PyriteCloud/cli/releases/download/v0.2.0/pyrite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "baa46f2960d4ea71d4e09488c0ea688327e7defa32a9ec5c79badcfdceef6369"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "pyrite"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pyrite"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pyrite"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pyrite"
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
