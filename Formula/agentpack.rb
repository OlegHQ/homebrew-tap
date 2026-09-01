class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.12/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "cec1dc618b3ac76c8aace7c843ba4b3a8eae76fe4f0576ca672c1fe5f3e2ec49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.12/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "7d1ff7bf707c7c1f855190bf38e73e44b6252ae6ad0c8252d5ee91c89bdb8e9d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.12/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "76cf905e9288dcaec646f0b677ee040397a357709af2b6142ad9f952cfa39f04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.12/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f53510e4b4939388e5b9a203f6fe912fa228f16dff272cbebae351275b12194"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "agentpack"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "agentpack"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "agentpack"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "agentpack"
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
