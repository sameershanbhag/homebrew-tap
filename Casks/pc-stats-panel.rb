cask "pc-stats-panel" do
  version "2.3"
  sha256 "9e171ddcf806266507e28f183ad37afb2bb12367bd1f14699cbaac6fd6d7db6c"

  url "https://github.com/sameershanbhag/pc-stats-dock/releases/download/v#{version}/PC-Stats-Panel-#{version}.dmg"
  name "PC Stats Panel"
  desc "Stats dock for a Magedok T101F touch panel: live Mac stats, touch buttons and feeds"
  homepage "https://github.com/sameershanbhag/pc-stats-dock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "PC Stats Panel.app"

  uninstall script:    {
              executable:   "#{appdir}/PC Stats Panel.app/Contents/MacOS/PCStatsPanel",
              args:         ["--uninstall"],
              must_succeed: false,
            },
            launchctl: "com.pcstatsdock.agent"

  zap trash: [
    "~/Applications/Stats Dock Admin.app",
    "~/Library/Application Support/pc-stats-dock",
    "~/Library/Caches/pc-stats-dock",
    "~/Library/Logs/pc-stats-dock",
  ]

  caveats <<~CAVEATS
    Open "PC Stats Panel" once: it installs itself as a login item and quits.
    Plug in the panel: the dashboard opens on it. Then switch on "PC Stats Panel" under
    System Settings > Privacy & Security > Accessibility (key buttons and touch need it).

    Optional:  brew install macmon                                   (temperatures and power)
               brew install jakehilborn/jakehilborn/displayplacer    (automatic screen arrangement)
  CAVEATS
end
