cask "kaleidoscope" do
  version "4.0.3,3824"
  sha256 "38dda0e1b49315256c45472ee9dd11f12b73d26f8745ee5237c651783a09acb7"

  url "https://updates.kaleidoscope.app/v#{version.major}/prod/Kaleidoscope-#{version.csv.first}-#{version.csv.second}.app.zip"
  name "Kaleidoscope"
  desc "Spot and merge differences in text and image files or folders"
  homepage "https://kaleidoscope.app/"

  livecheck do
    url "https://updates.kaleidoscope.app/v#{version.major}/prod/appcast"
    regex(/Kaleidoscope[._-]v?(\d+(?:\.\d+)+)[._-](\d+)\.app\.zip/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[0]},#{match[1]}" }
    end
  end

  auto_updates true
  conflicts_with cask: [
    "ksdiff",
    "homebrew/cask-versions/kaleidoscope2",
    "homebrew/cask-versions/ksdiff2",
  ]
  depends_on macos: ">= :big_sur"

  app "Kaleidoscope.app"

  postflight do
    contents = "#{appdir}/Kaleidoscope.app/Contents"
    system_command "#{contents}/Resources/Integration/scripts/install_ksdiff",
                   args: ["#{contents}/MacOS", "#{HOMEBREW_PREFIX}/bin"]
  end

  uninstall quit:    "app.kaleidoscope.v#{version.major}",
            pkgutil: "app.kaleidoscope.uninstall_ksdiff"

  zap trash: [
    "~/Library/Application Support/app.kaleidoscope.v*",
    "~/Library/Application Support/com.blackpixel.kaleidoscope",
    "~/Library/Application Support/Kaleidoscope",
    "~/Library/Caches/app.kaleidoscope.v*",
    "~/Library/Caches/com.blackpixel.kaleidoscope",
    "~/Library/Caches/com.plausiblelabs.crashreporter.data/com.blackpixel.kaleidoscope",
    "~/Library/Preferences/app.kaleidoscope.v*.plist",
    "~/Library/Preferences/com.blackpixel.kaleidoscope.plist",
    "~/Library/Saved Application State/app.kaleidoscope.v*.savedState",
    "~/Library/Saved Application State/com.blackpixel.kaleidoscope.savedState",
    "~/Library/WebKit/app.kaleidoscope.v*",
  ]
end
