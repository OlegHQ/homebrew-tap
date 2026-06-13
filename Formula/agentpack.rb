class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.4/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "ecdd03c459d48ebd6c29f49617785b72a7e95c8a173728dcae62b62049b7ae1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.4/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "ed37269a2a372e6bfab892a93dc0eb95f2969385772d330bd3ecbf7d484416cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.4/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b5dc4309149db16cc1bac93e264b44ea1916b5f8f4fd6150ebe04ccfff74ff5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.4/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae16042797ebeeeafcc8f19b3314ff23bf005ea30c92b100bc8d74e56ffb30cd"
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
