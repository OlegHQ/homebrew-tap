class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.11/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "40bc6e9a92cfa86ccbf23403fb4179027ec9d174a200f1c2679b513df17fdb57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.11/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "801d69cf4bdb66e592736ccb3dcf0f554bc72fc0e5352c9ed8916078d0436b9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.11/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "138f16ff04124a2cc5d7e01ef804372fef1f556801b5d348aa6a6e15fc379efd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.11/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d86dfbdf6544e364cdecf20cb68fb98966f2897ab4389ccff73a475b1b81345b"
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
