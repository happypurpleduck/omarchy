import QtQuick
import Quickshell.Io

Rectangle {
  id: module

  property string moduleName: ""
  property int interval: 5000
  property string clickCommand: ""
  property string rightClickCommand: ""
  property color foreground: "#cdd6f4"
  property color activeColor: "#a55555"
  property color background: "transparent"

  property string label: ""
  property string tooltip: ""
  property string className: ""

  function runCommand(command) {
    if (!command) return
    action.exec(["bash", "-lc", command])
  }

  function refresh() {
    if (!proc.running) proc.running = true
  }

  function applyPayload(raw) {
    try {
      var payload = JSON.parse(raw || "{}")
      label = payload.text || ""
      tooltip = payload.tooltip || ""
      className = payload.class || ""
    } catch (e) {
      label = ""
      tooltip = ""
      className = ""
    }
  }

  visible: label.length > 0
  implicitWidth: visible ? Math.max(12, textItem.implicitWidth) + 15 : 0
  implicitHeight: 26
  color: background

  Text {
    id: textItem
    anchors.centerIn: parent
    text: module.label
    color: module.className === "active" || module.className === "recording" || module.className === "critical" ? module.activeColor : module.foreground
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 12
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor
    onClicked: function(mouse) {
      if (mouse.button === Qt.RightButton)
        module.runCommand(module.rightClickCommand)
      else
        module.runCommand(module.clickCommand)
    }
  }

  Timer {
    interval: module.interval
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: module.refresh()
  }

  Process {
    id: proc
    command: ["bash", "-lc", "omarchy-quickshell-bar-module " + module.moduleName]
    stdout: SplitParser {
      onRead: function(data) {
        module.applyPayload(data)
      }
    }
    onExited: function(exitCode, exitStatus) {
      if (exitCode !== 0)
        module.applyPayload("{}")
    }
  }

  Process { id: action }
}
