import QtQuick
import QtQuick.Controls
import QtQuick.Particles 2.0
import QtQuick.Window
import QtMultimedia

Window {
    id: root
    width: 360
    height: 640
    visible: true
    title: "Loadiine"
    color: "black"

    // ==================== AUDIO ====================
    MediaPlayer {
        id: bgMusic
        source: "file:///data/sounds/bgMusic.ogg"
        audioOutput: AudioOutput { volume: 0.5 }
        Component.onCompleted: bgMusic.play()
        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.EndOfMedia) bgMusic.play()
        }
        onErrorOccurred: console.log("bgMusic error:", errorString)
    }

    MediaPlayer {
        id: sfxClick
        source: "file:///data/sounds/button_click.mp3"
        audioOutput: AudioOutput { volume: 1.0 }
    }

    MediaPlayer {
        id: sfxScreenSwitch
        source: "file:///data/sounds/screenSwitchSound.mp3"
        audioOutput: AudioOutput { volume: 1.0 }
    }

    MediaPlayer {
        id: sfxSettings
        source: "file:///data/sounds/settings_click_2.mp3"
        audioOutput: AudioOutput { volume: 1.0 }
    }

    function playClick() {
        sfxClick.stop()
        sfxClick.play()
    }
    function playScreenSwitch() {
        sfxScreenSwitch.stop()
        sfxScreenSwitch.play()
    }
    function playSettings() {
        sfxSettings.stop()
        sfxSettings.play()
    }

    // ==================== BUBBLES ====================
    ParticleSystem {
        id: bubbleSystem
        anchors.fill: parent
        running: true
        z: 0
    }

    Emitter {
        system: bubbleSystem
        anchors.bottom: parent.bottom
        width: parent.width
        height: 20
        emitRate: 5
        lifeSpan: 4500
        lifeSpanVariation: 1500
        velocity: AngleDirection {
            angle: 270; angleVariation: 30
            magnitude: 70; magnitudeVariation: 20
        }
        size: 3
        sizeVariation: 2
        maximumEmitted: 40
    }

    Emitter {
        system: bubbleSystem
        anchors.bottom: parent.bottom
        width: parent.width
        height: 20
        emitRate: 9
        lifeSpan: 5000
        lifeSpanVariation: 1500
        velocity: AngleDirection {
            angle: 270; angleVariation: 25
            magnitude: 85; magnitudeVariation: 25
        }
        size: 8
        sizeVariation: 3
        maximumEmitted: 30
    }

    Emitter {
        system: bubbleSystem
        anchors.bottom: parent.bottom
        width: parent.width
        height: 20
        emitRate: 2
        lifeSpan: 5500
        lifeSpanVariation: 1000
        velocity: AngleDirection {
            angle: 270; angleVariation: 20
            magnitude: 100; magnitudeVariation: 30
        }
        size: 16
        sizeVariation: 5
        maximumEmitted: 15
    }

    Timer {
        interval: 50; running: true; repeat: false
        onTriggered: bubbleSystem.burst(20)
    }

    Wander {
        system: bubbleSystem
        xVariance: 60; yVariance: 0
        pace: 180
        affectedParameter: Wander.Position
    }

    ItemParticle {
        system: bubbleSystem
        delegate: Rectangle {
            width: 8; height: 8; radius: width / 2
            color: "white"; opacity: 0.65
        }
    }

    // ==================== STACK ====================
    StackView {
        id: stack
        anchors.fill: parent
        z: 1
        initialItem: mainScreen
    }

    // ==================== MAIN SCREEN ====================
    Component {
        id: mainScreen
        Item {
            id: mainItem

            property int gridCols: 3
            property int cellW: 100
            property int cellH: 140
            property int gridTotalW: gridCols * cellW
            property int gridTotalH: Math.ceil(appModel.count / gridCols) * cellH
            property int appsPerPage: 6
            property int currentPage: 0
            property int totalPages: Math.ceil(appModel.count / appsPerPage)

            // ---- grid ----
            Item {
                id: gridArea
                width: mainItem.gridTotalW
                height: mainItem.cellH * 2
                anchors.centerIn: parent

                Repeater {
                    model: mainItem.appsPerPage
                    delegate: Item {
                        property int appIndex: mainItem.currentPage * mainItem.appsPerPage + index
                        visible: appIndex < appModel.count
                        width: mainItem.cellW
                        height: mainItem.cellH
                        x: (index % mainItem.gridCols) * mainItem.cellW
                        y: Math.floor(index / mainItem.gridCols) * mainItem.cellH

                        Rectangle {
                            id: glowRing
                            anchors.centerIn: iconContainer
                            width: iconContainer.width + 16
                            height: iconContainer.height + 16
                            radius: 22
                            color: "transparent"
                            border.color: "#00aaff"
                            border.width: hoverArea.containsMouse ? 2 : 0
                            opacity: hoverArea.containsMouse ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 180 } }

                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width + 10
                                height: parent.height + 10
                                radius: parent.radius + 5
                                color: "transparent"
                                border.color: "#0066cc"
                                border.width: 1.5
                                opacity: 0.5
                            }
                            Rectangle {
                                anchors.centerIn: parent
                                width: parent.width + 20
                                height: parent.height + 20
                                radius: parent.radius + 10
                                color: "transparent"
                                border.color: "#003388"
                                border.width: 1
                                opacity: 0.25
                            }
                        }

                        Rectangle {
                            id: iconContainer
                            width: 80; height: 80
                            radius: 16
                            color: "transparent"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 10
                            clip: true
                            border.color: hoverArea.containsMouse ? "#00aaff" : "transparent"
                            border.width: 2
                            Behavior on border.color { ColorAnimation { duration: 180 } }
                            scale: hoverArea.containsMouse ? 1.05 : 1.0
                            Behavior on scale { NumberAnimation { duration: 150 } }

                            Image {
                                source: "file:///data/images/iconEmpty.jpg"
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }

                        Text {
                            text: appModel.get(appIndex) ? appModel.get(appIndex).title : ""
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10
                            color: "white"
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.playClick()
                                console.log("Launch:", appIndex)
                            }
                        }
                    }
                }
            }

            // ---- Page dots ----
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 80
                spacing: 8
                Repeater {
                    model: mainItem.totalPages
                    Rectangle {
                        width: 8; height: 8; radius: 4
                        color: index === mainItem.currentPage ? "white" : "#555"
                    }
                }
            }

            // ---- Left arrow ----
            Image {
                source: "file:///data/images/leftArrow.png"
                width: 25; height: 70
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                visible: mainItem.currentPage > 0
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.playClick()
                        if (mainItem.currentPage > 0) mainItem.currentPage--
                    }
                }
            }

            // ---- right arrow ----
            Image {
                source: "file:///data/images/rightArrow.png"
                width: 25; height: 70
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                visible: mainItem.currentPage < mainItem.totalPages - 1
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.playClick()
                        if (mainItem.currentPage < mainItem.totalPages - 1) mainItem.currentPage++
                    }
                }
            }

            // ---- Settings button ----
            Image {
                source: "file:///data/images/settingsButton.png"
                width: 72; height: 72
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.playSettings()
                        stack.push(settingsScreen)
                    }
                }
            }

            // ---- Layout switch button----
            Image {
                source: "file:///data/images/layoutSwitchButton.png"
                width: 80; height: 80
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.playScreenSwitch()
                        console.log("Switch view")
                    }
                }
            }
        }
    }

    // ==================== SETTINGS SCREEN ====================
    Component {
        id: settingsScreen
        Item {
            id: settingsItem

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.55
                z: 0
            }

            Item {
                id: topBanner
                width: parent.width
                height: 72
                anchors.top: parent.top
                z: 2

                Image {
                    source: "file:///data/images/settingsTitle.png"
                    anchors.fill: parent
                    fillMode: Image.Stretch
                }

                Text {
                    text: "Settings"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true
                }
            }

            // ---- Settings list (Will be replacved as a page view later)----
            ListView {
                anchors.top: topBanner.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 20
                anchors.bottomMargin: 80
                spacing: 8
                z: 2
                model: ["GUI", "Apps", "Theme", "Sounds", "Credits"]
                delegate: Rectangle {
                    width: parent.width; height: 58
                    color: "#1e90ff22"; radius: 6
                    Text {
                        text: modelData
                        anchors.centerIn: parent
                        color: "white"; font.pixelSize: 17
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.playClick()
                            // Toggle music off if "Sounds" tapped, prototype only, will make a settings page with sound settings
                            if (modelData === "Sounds") {
                                bgMusic.playing ? bgMusic.pause() : bgMusic.play()
                            }
                            console.log("Opened:", modelData)
                        }
                    }
                }
            }

            Image {
                source: "file:///data/images/backButton.png"
                width: 72; height: 72
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                fillMode: Image.PreserveAspectFit
                z: 2
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.playClick()
                        stack.pop()
                    }
                }
            }
        }
    }

    // ==================== APPS (will be replaced) ====================
    ListModel {
        id: appModel
        ListElement { title: "App 1" }
        ListElement { title: "App 2" }
        ListElement { title: "App 3" }
        ListElement { title: "App 4" }
        ListElement { title: "App 5" }
        ListElement { title: "App 6" }
        ListElement { title: "App 7" }
        ListElement { title: "App 8" }
    }
}