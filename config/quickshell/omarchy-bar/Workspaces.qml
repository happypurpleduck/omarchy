import QtQuick
import Quickshell.Io

Row {
  id: workspaces

  property color foreground: "#cdd6f4"
  property color background: "transparent"

  spacing: 3

  property var rows: []

  function applyPayload(raw) {
    try {
      rows = JSON.parse(raw || "{}").workspaces || []
    } catch (e) {
      rows = []
    }
  }

  Repeater {
    model: workspaces.rows

    Rectangle {
      required property var modelData

      width: 21
      height: 26
      color: workspaces.background
      opacity: modelData.empty ? 0.5 : 1

      Text {
        anchors.centerIn: parent
        text: modelData.active ? "󱓻" : modelData.label
        color: workspaces.foreground
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 12
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: action.exec(["bash", "-lc", "hyprctl dispatch 'hl.dsp.focus({ workspace = \"" + modelData.id + "\" })'"])
      }
    }
  }

  Process {
    id: watcher
    running: true
    command: ["bash", "-lc", "omarchy-quickshell-bar-workspaces-watch"]
    stdout: SplitParser {
      onRead: function(data) {
        workspaces.applyPayload(data)
      }
    }
    onExited: function(exitCode, exitStatus) {
      restartTimer.start()
    }
  }

  Timer {
    id: restartTimer
    interval: 1000
    repeat: false
    onTriggered: watcher.running = true
  }

  Process { id: action }
}
