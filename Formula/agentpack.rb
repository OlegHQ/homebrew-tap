class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.10/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "b6e246503974e1a483b90a67fab71e3af36287b4093e400c204836953a86114a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.10/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "69dcdb803152a8d277631fdf5ebb0e0a766f53202b17da381ba69841ceee563e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.10/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b16bcf451779685f83c62ebe238e064a898eea88f1d579cab95fde99b24ea44"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.10/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f1d312e5fda834012ac4c0340a3319b03ddcd4492bf10199778a6ea666eaa6f"
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
