cask "pc-stats-panel" do
  version "2.9"
  sha256 "1e9fdbba265e9bdfff7bf5fe013af587ce885b8b7ba4bc2fb8bd2de21ae316bb"

  url "https://github.com/sameershanbhag/pc-stats-dock/releases/download/v#{version}/PC-Stats-Panel-#{version}.dmg"
  name "PC Stats Panel"
  desc "Stats dock for a Magedok T101F touch panel: live Mac stats, touch buttons and feeds"
  homepage "https://github.com/sameershanbhag/pc-stats-dock"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "PC Stats Panel.app"

  # Registers (or re-registers, after an upgrade) the login item; no dialog.
  postflight do
    system_command "#{appdir}/PC Stats Panel.app/Contents/MacOS/PCStatsPanel", args: ["--setup"], must_succeed: false
  end

  # Stops the agent and removes the login item; the Accessibility grant and your buttons survive an upgrade.
  uninstall launchctl: "com.pcstatsdock.agent",
            script:    {
              executable:   "#{appdir}/PC Stats Panel.app/Contents/MacOS/PCStatsPanel",
              args:         ["--uninstall"],
              must_succeed: false,
            }

  zap script: {
        executable:   "#{appdir}/PC Stats Panel.app/Contents/MacOS/PCStatsPanel",
        args:         ["--purge"],
        must_succeed: false,
      },
      trash: [
        "~/Applications/Stats Dock Admin.app",
        "~/Library/Application Support/pc-stats-dock",
        "~/Library/Caches/pc-stats-dock",
        "~/Library/Logs/pc-stats-dock",
      ]

  caveats <<~CAVEATS
    The login item is registered already. Plug in the panel: the dashboard opens on it.
    Then switch on "PC Stats Panel" under System Settings > Privacy & Security > Accessibility
    (key buttons and touch need it; the switch survives upgrades).

    Optional:  brew install macmon                                   (temperatures and power)
               brew install jakehilborn/jakehilborn/displayplacer    (automatic screen arrangement)
  CAVEATS
end
