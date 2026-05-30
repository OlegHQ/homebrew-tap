class Agentpack < Formula
  desc "Pin GitHub-hosted skills and plugin directories for agent harnesses"
  homepage "https://github.com/OlegHQ/agentpack"
  url "https://github.com/OlegHQ/agentpack/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e8fa2ba99d6f2631b4351aa02df9985f4d380e707ee3097e0a0774ad1b004088"
  license "MIT"
  head "https://github.com/OlegHQ/agentpack.git", branch: "dev"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentpack --version")
  end
end
