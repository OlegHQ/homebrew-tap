class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.1/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "03ff5b0dcea30bf71e9ded16c179d3e62196d10e5093d3a69aa622498e26d672"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.1/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "b692d18818e872a4ab9d28816213a7b0d52d8676672e58884e09dd4276234eb2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.1/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1053121acf735b7a6393220adbb66218d482f3a2c01f8d7e9137b0197daadcec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.1/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c74efeb8ffceda7d6693908208e3beba6b509da31255dae073c6cc6ef8c09cb"
    end
  end
  license "MIT"

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
    bin.install "agentpack" if OS.mac? && Hardware::CPU.arm?
    bin.install "agentpack" if OS.mac? && Hardware::CPU.intel?
    bin.install "agentpack" if OS.linux? && Hardware::CPU.arm?
    bin.install "agentpack" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
