class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.7/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "a2c78490651ccf8b177e4202e011f2385ab627d00485335db1f73011e54da601"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.7/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "8b1d3749810128229a2b48047011ad534185ef1c29f867187004bc676326b60e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.7/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fd310bf25c2751bc87ba44f86c6be8ad67dbbcd5f9e64ce8cb9d3f9c7df6e8a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.7/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e64df35ce7e95e72c1dce0785e126b347c62a382667700907c1f0069bc1fcb17"
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
