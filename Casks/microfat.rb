# Generated from authenticated official release assets. Do not edit by hand.
cask "microfat" do
  arch arm: "arm64", intel: "amd64"

  version "0.3.1"
  sha256 arm64_linux:  "998a75a54ab401cba3ef527db7986133dc8768a830b8ec4ea69bfba410ed6b39",
         x86_64_linux: "c8b39f5315546201ee696cb435d0c2a6d29c36fa4b47bd848aef3af94c93f3ca"

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
