# Generated from authenticated official release assets. Do not edit by hand.
cask "microfat" do
  arch arm: "arm64", intel: "amd64"

  version "0.4.0"
  sha256 arm64_linux:  "a9a59f83a9f6386ef76c6f81635c55ed4fe8b8d224df4e36fefa35c7ad305153",
         x86_64_linux: "004934f37241ff2f90b2436de73341e80a74d6d50ce0c179556d9abbe93c73b9"

  url "https://github.com/EpicBlackWolfZ/microfat/releases/download/v#{version}/microfat_#{version}_linux_#{arch}.tar.gz"
  name "microfat"
  desc "Microarchitecture-specialized Go executables"
  homepage "https://github.com/EpicBlackWolfZ/microfat"

  depends_on arch: [:x86_64, :arm64]
  depends_on :linux

  binary "microfat"
  binary "microfat-stub"
  binary "microfat-stub-minimal"

  preflight_steps do
    write_file "microfat-distribution.json", '{"schema":1,"owner":"homebrew"}', append_newline: true
    set_permissions "microfat-distribution.json", "0644"
  end
end
