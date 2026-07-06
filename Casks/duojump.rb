cask "duojump" do
  version "1.0.0"
  sha256 "efd25b915c3a0e1dde7235feb595d328c0e78fc79b027b08cf0ed0578c81ae53"

  url "https://github.com/PavlovIvan1/2d-macos-game/archive/refs/tags/v#{version}.tar.gz"
  name "DuoJump"
  desc "Local split-screen 2-player co-op platformer, built with Godot"
  homepage "https://github.com/PavlovIvan1/2d-macos-game"

  depends_on cask: "godot"
  depends_on macos: :big_sur

  preflight do
    pkg_dir = Pathname.glob(staged_path/"**/project.godot").first.dirname

    app_dir = staged_path/"DuoJump.app"
    (app_dir/"Contents/MacOS").mkpath
    (app_dir/"Contents/Resources").mkpath

    game_dir = app_dir/"Contents/Resources/game"
    FileUtils.rm_rf(game_dir)
    FileUtils.cp_r(pkg_dir, game_dir)

    godot_bin = "/Applications/Godot.app/Contents/MacOS/Godot"

    File.write(app_dir/"Contents/MacOS/DuoJump", <<~SCRIPT)
      #!/bin/bash
      DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
      exec "#{godot_bin}" --path "$DIR/../Resources/game"
    SCRIPT
    FileUtils.chmod("+x", app_dir/"Contents/MacOS/DuoJump")

    File.write(app_dir/"Contents/Info.plist", <<~PLIST)
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>CFBundleExecutable</key>
          <string>DuoJump</string>
          <key>CFBundleIdentifier</key>
          <string>com.example.DuoJump</string>
          <key>CFBundleName</key>
          <string>DuoJump</string>
          <key>CFBundlePackageType</key>
          <string>APPL</string>
          <key>CFBundleShortVersionString</key>
          <string>#{version}</string>
          <key>CFBundleVersion</key>
          <string>1</string>
          <key>LSMinimumSystemVersion</key>
          <string>11.0</string>
          <key>NSHighResolutionCapable</key>
          <true/>
      </dict>
      </plist>
    PLIST
  end

  app "DuoJump.app"
end
