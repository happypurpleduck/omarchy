//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland._WlrLayerShell

ShellRoot {
  id: root

  property string home: Quickshell.env("HOME") || "/home/husain"
  property string themeFile: home + "/.config/omarchy/current/theme/quickshell.json"
  property string position: Quickshell.env("OMARCHY_QUICKSHELL_BAR_POSITION") || "top"
  property int barSize: position === "left" || position === "right" ? 28 : 26
  property color backgroundColor: "#1e1e2e"
  property color foregroundColor: "#cdd6f4"
  property color activeColor: "#a55555"
  property bool showDateDetails: false

  function loadTheme(raw) {
    try {
      var theme = JSON.parse(raw || "{}")
      backgroundColor = theme.background || backgroundColor
      foregroundColor = theme.backgroundText || foregroundColor
    } catch (e) {}
  }

  function run(command) {
    if (command)
      action.exec(["bash", "-lc", command])
  }

  FileView {
    path: root.themeFile
    watchChanges: true
    onLoaded: root.loadTheme(text())
    onFileChanged: {
      reload()
      root.loadTheme(text())
    }
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: true
      anchors {
        top: root.position !== "bottom"
        bottom: root.position !== "top"
        left: root.position !== "right"
        right: root.position !== "left"
      }
      implicitWidth: root.barSize
      implicitHeight: root.barSize
      exclusiveZone: root.barSize
      color: "transparent"
      WlrLayershell.namespace: "omarchy-quickshell-bar"
      WlrLayershell.layer: WlrLayer.Top
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      Rectangle {
        anchors.fill: parent
        color: root.backgroundColor

        Row {
          anchors.left: parent.left
          anchors.leftMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          spacing: 0

          Rectangle {
            width: root.barSize
            height: root.barSize
            color: "transparent"

            Text {
              anchors.centerIn: parent
              text: "\ue900"
              color: root.foregroundColor
              font.family: "omarchy"
              font.pixelSize: 13
            }

            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              cursorShape: Qt.PointingHandCursor
              onClicked: function(mouse) {
                root.run(mouse.button === Qt.RightButton ? "xdg-terminal-exec" : "omarchy-menu")
              }
            }
          }

          Workspaces { foreground: root.foregroundColor }
        }

        Row {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          spacing: 0

          Text {
            width: implicitWidth + 18
            height: root.barSize
            text: root.showDateDetails ? Qt.formatDateTime(clock.date, "dd MMMM yyyy") : Qt.formatDateTime(clock.date, "dddd HH:mm")
            color: root.foregroundColor
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            MouseArea {
              anchors.fill: parent
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              cursorShape: Qt.PointingHandCursor
              onClicked: function(mouse) {
                if (mouse.button === Qt.RightButton)
                  root.run("omarchy-launch-floating-terminal-with-presentation omarchy-tz-select")
                else
                  root.showDateDetails = !root.showDateDetails
              }
            }
          }

          StatusModule { moduleName: "weather"; interval: 60000; foreground: root.foregroundColor; activeColor: root.activeColor; clickCommand: "notify-send -u low \"$(omarchy-weather-status)\"" }
        }

        Row {
          anchors.right: parent.right
          anchors.rightMargin: 8
          anchors.verticalCenter: parent.verticalCenter
          spacing: 0

          TrayItems { trayWindow: panel }
          StatusModule { moduleName: "network"; interval: 3000; foreground: root.foregroundColor; activeColor: root.activeColor; clickCommand: "omarchy-launch-wifi" }
          StatusModule { moduleName: "audio"; interval: 1000; foreground: root.foregroundColor; activeColor: root.activeColor; clickCommand: "omarchy-launch-audio"; rightClickCommand: "pamixer -t" }
          StatusModule { moduleName: "cpu"; interval: 5000; foreground: root.foregroundColor; activeColor: root.activeColor; clickCommand: "omarchy-launch-or-focus-tui btop"; rightClickCommand: "alacritty" }
          StatusModule { moduleName: "bluetooth"; interval: 3000; foreground: root.foregroundColor; activeColor: root.activeColor; clickCommand: "omarchy-launch-bluetooth" }
          StatusModule { moduleName: "battery"; interval: 5000; foreground: root.foregroundColor; activeColor: root.activeColor; clickCommand: "omarchy-menu power"; rightClickCommand: "notify-send -u low \"$(omarchy-battery-status)\"" }
        }
      }
    }
  }

  Process { id: action }
}
