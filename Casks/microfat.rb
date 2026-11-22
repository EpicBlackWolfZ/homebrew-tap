# Generated from authenticated official release assets. Do not edit by hand.
cask "microfat" do
  arch arm: "arm64", intel: "amd64"

  version "0.4.1"
  sha256 arm64_linux:  "d00752e0612d3bde8e714d94bcfd9bfa88dddd63b70ec44467653d591a95a367",
         x86_64_linux: "d79a2b8ddded73a1280a241655d1f42269351799d43d968daa4e01a107b456f1"

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
