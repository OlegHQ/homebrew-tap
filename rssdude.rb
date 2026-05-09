class Rssdude < Formula
  desc "Local-first RSS feed reader and content curation CLI"
  homepage "https://github.com/OlegHQ/rssdude"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/OlegHQ/rssdude/releases/download/v#{version}/rssdude-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "a08438e100ee28d8f2b6dabcb2a4fabe525da988377d75bf8013a04b013870b3"
    end
    on_intel do
      odie "rssdude v#{version} ships only as arm64; x86_64 build is planned."
    end
  end

  def install
    bin.install "rssdude"
  end

  test do
    assert_match "rssdude #{version}", shell_output("#{bin}/rssdude --version")
  end
end
