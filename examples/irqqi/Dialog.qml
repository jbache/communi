/*
* Copyright (C) 2008-2011 J-P Nurmi jpnurmi@gmail.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*/

import QtQuick 1.0
import QtDesktop 0.1

Window {
    id: dialog

    width: 1.5 * column.width
    height: 1.5 * column.height

    property alias host: hostField.text
    property alias name: nameField.text

    signal connect()

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 6

        Grid {
            columns: 2
            spacing: 6

            Text { text: qsTr("Host:") }

            TextField {
                id: hostField
                text: "irc.freenode.net"
                KeyNavigation.tab: nameField
                Component.onCompleted: forceActiveFocus()
            }

            Text { text: qsTr("Name:") }
            TextField { id: nameField ; KeyNavigation.tab: closebutton}
            Item { height: 30; width: 30}
        }
    }
    Row {
        spacing: 6
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 10
        anchors.bottomMargin: 6
        Button {
            id: closebutton
            text: qsTr("Quit")
            onClicked: Qt.quit()

            width:100
            KeyNavigation.tab: connectbutton
        }
        Button {
            id: connectbutton
            text: qsTr("Connect")
            enabled: dialog.host.length && dialog.name.length
            onClicked: dialog.connect()
            width:100
            defaultbutton: true
        }
    }
}
