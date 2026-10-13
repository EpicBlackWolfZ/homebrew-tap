# Generated from authenticated official release assets. Do not edit by hand.
cask "microfat" do
  arch arm: "arm64", intel: "amd64"

  version "0.3.0"
  sha256 arm64_linux:  "f540e09f3461a04615808f7e0e82a93af9f2f9f7129bd27fd74152682b39cdcc",
         x86_64_linux: "990a92d49897bf4d9b573c09b1d3051d8da1ea6538f42605289bcbc09f9940f0"

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
