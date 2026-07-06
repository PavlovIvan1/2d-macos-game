#!/bin/bash
set -e

APP_NAME="DuoJump"
GODOT_BIN="/Applications/Godot.app/Contents/MacOS/Godot"
APP_BUNDLE="$APP_NAME.app"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$REPO_DIR/game"

if [ ! -x "$GODOT_BIN" ]; then
    echo "Godot.app not found. Install it first: brew install --cask godot"
    exit 1
fi

echo "Assembling $APP_BUNDLE..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cat > "$APP_BUNDLE/Contents/MacOS/$APP_NAME" <<EOF
#!/bin/bash
exec "$GODOT_BIN" --path "$PROJECT_DIR"
EOF
chmod +x "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

cat > "$APP_BUNDLE/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.$APP_NAME</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "Done: $APP_BUNDLE (run: open $APP_BUNDLE)"
