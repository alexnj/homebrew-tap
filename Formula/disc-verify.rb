class DiscVerify < Formula
  include Language::Python::Shebang

  desc "Verify that every sector of a CD, DVD or Blu-ray is readable"
  homepage "https://github.com/alexnj/disc-verify"
  url "https://github.com/alexnj/disc-verify/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ad4e6ccb9bfa0d891ffc3698c458925777526eee4c15f727a1b3fb9c9f748409"
  license "Apache-2.0"

  depends_on "libdvdcss"
  depends_on :macos
  depends_on "python@3.14"

  def install
    inreplace "disc-verify", "LIBDVDCSS_PATH = None",
              "LIBDVDCSS_PATH = \"#{formula_opt_lib("libdvdcss")}/libdvdcss.2.dylib\""
    rewrite_shebang detected_python_shebang, "disc-verify"
    bin.install "disc-verify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/disc-verify --version")
    (testpath/"test.iso").binwrite("\0" * 2048 * 64)
    assert_match "OK: all 64 sectors", shell_output("#{bin}/disc-verify --device #{testpath}/test.iso")
  end
end
