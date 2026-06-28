class Agentpack < Formula
  desc "The package manager for AI coding agents — pin, resolve, and sync skills & plugins across Claude Code, Cursor, OpenCode, and Codex"
  homepage "https://github.com/OlegHQ/agentpack"
  version "0.3.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.8/agentpack-aarch64-apple-darwin.tar.xz"
      sha256 "877a4d8f88c07ebec547de481c23a9de96c3fe60f6ae56fac9556547544c32dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.8/agentpack-x86_64-apple-darwin.tar.xz"
      sha256 "17971a56629c2ba72134ffda254a46a0f50831ea64f86d771130aea61a0c27c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.8/agentpack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd20354f4952c30938a91bd456ccfe83e6b3fe595016ef75883472c99a4e80e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/OlegHQ/agentpack/releases/download/v0.3.8/agentpack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "54af5da165362bd88eacaf3cdf9d051bc7ecde56b0ae514e28a892d3021c98b1"
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
