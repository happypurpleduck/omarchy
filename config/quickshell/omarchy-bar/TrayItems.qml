import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Row {
  id: tray

  property color background: "transparent"
  property var trayWindow: null

  function iconSource(icon) {
    if (!icon)
      return ""

    if (icon.indexOf("/") === 0 || icon.indexOf("file:") === 0 || icon.indexOf("image:") === 0 || icon.indexOf("qrc:") === 0)
      return icon

    return Quickshell.iconPath(icon)
  }

  spacing: 8
  width: childrenRect.width
  height: 26

  Repeater {
    model: SystemTray.items

    Rectangle {
      required property SystemTrayItem modelData
      property int pendingButton: Qt.NoButton
      property real pendingX: 0
      property real pendingY: 0

      width: 18
      height: 26
      color: tray.background

      function displayMenu(x, y) {
        if (modelData.hasMenu && tray.trayWindow) {
          var pos = clickArea.mapToItem(null, x, y)
          modelData.display(tray.trayWindow, pos.x, pos.y)
        } else {
          modelData.activate()
        }
      }

      function handleSingleClick(button, x, y) {
        if (button === Qt.RightButton && !modelData.hasMenu)
          modelData.secondaryActivate()
        else
          displayMenu(x, y)
      }

      IconImage {
        anchors.centerIn: parent
        width: 12
        height: 12
        source: tray.iconSource(modelData.icon)
      }

      MouseArea {
        id: clickArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) {
          pendingButton = mouse.button
          pendingX = mouse.x
          pendingY = mouse.y
          singleClickTimer.restart()
        }
        onDoubleClicked: function(mouse) {
          singleClickTimer.stop()
          if (mouse.button === Qt.LeftButton)
            modelData.activate()
          else
            handleSingleClick(mouse.button, mouse.x, mouse.y)
        }
      }

      Timer {
        id: singleClickTimer
        interval: Qt.styleHints ? Qt.styleHints.mouseDoubleClickInterval : 400
        repeat: false
        onTriggered: handleSingleClick(pendingButton, pendingX, pendingY)
      }
    }
  }
}
