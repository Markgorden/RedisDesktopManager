import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.2
import "."
import "./editors/formatters/formatters.js" as Formatters

Rectangle {
    id: approot
    color: "transparent"
    property var currentValueFormatter

    TabView {
        id: tabs
        anchors.fill: parent
        anchors.margins: 2
        currentIndex: 0

        onCurrentIndexChanged: {

            var index = currentIndex

            if (tabs.getTab(0).not_mapped)
                index -= 1

            console.log(index)

            viewModel.setCurrentTab(index)
        }

        WelcomeTab {
            property bool not_mapped: true

            function close(index) {
                tabs.removeTab(index)
            }
        }

        ValueTabs {
            model: viewModel
        }

        style: TabViewStyle {
            tab: Rectangle {
                color: "#cccccc"
                implicitWidth: layout.implicitWidth + 3
                implicitHeight: 35
                radius: 3

                Rectangle {
                    id: content
                    color: styleData.selected ? "white" :"#cccccc"
                    anchors.fill: parent
                    anchors.topMargin: styleData.selected
                    anchors.rightMargin: styleData.selected
                    anchors.leftMargin: styleData.selected

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.rightMargin: 8

                        Item { Layout.preferredWidth: 3 }

                        Text {
                            Layout.fillWidth: true
                            Layout.minimumWidth: implicitWidth
                            color: "red"
                            text: styleData.title
                        }
                        Button {
                            text: "x"
                            Layout.maximumWidth: 18
                            Layout.maximumHeight: 18
                            Layout.preferredWidth: 18
                            Layout.preferredHeight: 18
                            onClicked: {
                                tabs.getTab(styleData.index).close(styleData.index)
                            }

                            style: ButtonStyle {
                                    background: Rectangle {
                                        border.width: control.hovered? 1 : 0
                                        border.color: control.hovered? "#000" : "#fff"
                                        radius: 0
                                        color:  control.hovered? "red" : "#fff"
                                    }
                                }
                        }
                    }
                }
            }

            frame: Rectangle {
                color: "#cccccc"

                Rectangle {
                    color: "white"
                    anchors.fill: parent
                    anchors.bottomMargin: 1
                    anchors.leftMargin: 1
                    anchors.rightMargin: 1
                    anchors.topMargin: 1
                }
            }
        }

    }


    MessageDialog {
        id: errorNotification
        visible: false
        modality: Qt.WindowModal
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ok
    }


    Connections {
        target: viewModel
        onKeyError: {
            tabs.currentIndex = index + 1
            errorNotification.text = error
            errorNotification.open()
        }
        onCloseWelcomeTab: {

            var welcomeTab = tabs.getTab(0)

            if (welcomeTab && welcomeTab.not_mapped)
               tabs.removeTab(0)
        }
    }
}