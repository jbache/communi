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
import Communi 1.0
import Communi.examples 1.0

Item {
    // An empty item will suppress the QML Viewer
    Window {
        id: window
        width: 640
        height: 480

        visible: true


        ToolBar {
            id: toolbar
            height: 40
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            Row {
                anchors.left: parent.left
                ToolButton {
                    iconName: "list-add"
                }
                ToolButton {
                    iconName: "list-remove"
                }
                ToolButton {
                    iconName: "help-browser"
                }
                ToolButton {
                    iconName: "preferences-system"
                    onClicked: settingsDialog.visible = true
                }
            }
        }

        Dialog {
            id: dialog
            modal: true
            host: "irc.lnx.nokia.com"
            onConnect: {
                mainPage.title = dialog.host;
                session.host = dialog.host;
                session.userName = dialog.name;
                session.nickName = dialog.name;
                session.realName = dialog.name;
                session.open();
                dialog.visible = false;
            }
        }
        Window {
            id: settingsDialog

            width: 300
            height: 200
            modal: true

            minimumWidth:  width
            minimumHeight: height
            maximumWidth:  width
            maximumHeight: height

            GroupBox {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: closebutton.top
                anchors.margins: 8
                title: "Settings"
            }

            Button {
                id: closebutton
                text: "Close"
                anchors.margins: 8
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: settingsDialog.visible = false
            }
        }

        Component.onCompleted: dialog.visible = true;
        SplitterRow {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: toolbar.bottom

            TextArea {
                id: channellist
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 200
                frame: false
                color: "#f4f4ff"
                activeFocusOnPress: false
                text: "Test\nTest2"
            }

            Item {
                TabFrame {
                    id: tabFrame

                    anchors.fill: parent
                    anchors.margins: 9
                    frame: false

                    Page {
                        id: mainPage
                        anchors.fill: parent
                        title: qsTr("Home")
                        onSendMessage: session.sendMessage(receiver, message)
                    }
                }
            }


        }
        Component {
            id: pageComponent
            Page { }
        }

        MessageHandler {
            id: handler
            qml: true
            session: session
            currentReceiver: tabFrame.count ? tabFrame.tabs[tabFrame.current] : null
            defaultReceiver: mainPage
            onReceiverToBeAdded: {
                tabFrame.addTab(pageComponent);
                var page = tabFrame.tabs[tabFrame.count-1];
                page.sendMessage.connect(session.sendMessage);
                page.title = name;
                handler.addReceiver(name, page);
            }
            onReceiverToBeRemoved: {
                var page = handler.getReceiver(name);
                tabFrame.current -= 1;
                page.destroy();
            }
        }

        IrcSession {
            id: session

            onConnecting: console.log("connecting...")
            onConnected: console.log("connected...")
            onDisconnected: Qt.quit();

            function sendMessage(receiver, message) {
                var cmd = CommandParser.parseCommand(receiver, message);
                if (cmd)
                    session.sendCommand(cmd);
            }
        }
    }
}
