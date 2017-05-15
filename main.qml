import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtMultimedia 5.5

import "XorGameQuick.js" as Logic

ApplicationWindow {

    id: mainWindow
    visible: true
    visibility: "Windowed"
    width: 960
    height: 540
    property bool isFullScreen: false;

    title: qsTr("XorGame 1.0")

    property int state: 0;

    property var playerAObjects: []
    property var playerBObjects: []
    property var timers: []

    //Scores of player A
    property int playerAScore: 0
    //Scores of player B
    property int playerBScore: 0

    Component.onCompleted: {
        mediaplayer.play();
        newGame();
    }

    background: Image {
        source: "deep-space.jpg"
    }

    //handle clicks
    MouseArea {
        anchors.fill: parent
        onClicked: {
            for(var i = 0; i < playerAObjects.length; ++i) {
                playerAObjects[i].selected = false;
            }
            for(var i = 0; i < playerBObjects.length; ++i) {
                playerBObjects[i].selected = false;
            }
        }
    }

    //play music
    MediaPlayer {
        id: mediaplayer
        source: "Star_Wars_-_Fantasy_Suite_Movement_2_-_Jarrod_Radnich_Virtuosic_Piano_Solo_4K[YoutubeConverter.Me].mp3"
        volume: volumeSlider.value
    }

    //volume slider
    Slider {
        id: volumeSlider
        x: mainWindow.width * 0.9
        y: mainWindow.height * 0.02
        value: 0.2
        height: mainWindow.height * 0.02;
        width: mainWindow.width * 0.1;
    }
    //and speaker icon
    Image {
        x: mainWindow.width * 0.88
        y: mainWindow.height * 0.015
        width: parent.width * 0.02
        height: width
        source: "speaker.png"
    }

    //fullscreen switcher
    Image {
        id: screenSwitcher
        x: mainWindow.width * 0.96
        y: mainWindow.height * 0.93
        width: mainWindow.width * 0.03
        height: width
        source: isFullScreen ? "windowed.png" : "fullscreen.png"

        MouseArea {
            anchors.fill: screenSwitcher
            onClicked: {
                if(mainWindow.isFullScreen){
                    mainWindow.visibility = "Windowed";
                    mainWindow.isFullScreen = false;
                }
                else {
                    mainWindow.visibility = "FullScreen";
                    mainWindow.isFullScreen = true;
                }
            }
        }
    }


    // Show Player A scores at the top
    Rectangle {
        color: "black"
        height: parent.height / 8
        width: parent.width / 8
        opacity: 50

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: parent.height * 0.02
        anchors.leftMargin: parent.height * 0.02
        border.color: "White"

        Text {
            id: playerAScoreText
            color: "White"
            font.pixelSize: parent.height < parent.width ? parent.height * 0.3 : parent.width * 0.3
            anchors.centerIn: parent
            text: "Player A: \n" + playerAScore
        }
    } // show player A

    // Show Player B scores at the bottom
    Rectangle {
        color: "black"
        height: parent.height / 8
        width: parent.width / 8
        opacity: 50

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: parent.height * 0.02
        anchors.leftMargin: parent.height * 0.02
        border.color: "White"

        Text {
            id: playerBScoreText
            color: "White"
            font.pixelSize: parent.height < parent.width ? parent.height * 0.3 : parent.width * 0.3
            anchors.centerIn: parent
            text: "Player B: \n" + playerBScore
        }
    } // show player B

    //new game button
    Rectangle {
        id: newGameButton
        height: parent.height / 15
        width: height * 3
        x: parent.width / 2 - width - 10
        y: parent.height * 0.01
        border.color: "#00fff6"
        radius: 10
        Image {
            id: newgameimg
            source: "NewGameButton.png"
            anchors.fill: parent
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                newgameimg.source = "NewGameHover.png"
                newgameimg.height = parent.height
                newgameimg.width = parent.width
                parent.border.color = "#f7e600"
            }
            onExited:  {
                newgameimg.source = "NewGameButton.png"
                newgameimg.height = parent.height
                newgameimg.width = parent.width
                parent.border.color = "#00fff6"
            }
            onClicked: newGame()
        }
        color: "transparent"
    } // new game button

    //close game button
    Rectangle {
        id: closeButton
        height: parent.height / 15
        width: height * 2.5
        x: parent.width * 0.5 + 10
        y: parent.height * 0.01
        Image {
            id: closegameimg
            source: "CloseButton.png"
            anchors.fill: parent
        }
        border.color: "#00fff6"
        radius: 10
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                closegameimg.source = "CloseHovered.png"
                closegameimg.height = parent.height
                closegameimg.width = parent.width
                parent.border.color = "#f7e600"
            }
            onExited:  {
                closegameimg.source = "CloseButton.png"
                closegameimg.height = parent.height
                closegameimg.width = parent.width
                parent.border.color = "#00fff6"
            }
            onClicked: {
                console.log("close!")
                Qt.quit()
            }
        }
        color: "Transparent"
    } // close button


    //new game
    function newGame() {
        // delete old game
        for(var i = 0; i < playerAObjects.length; ++i) {
            if(playerAObjects[i])
                playerAObjects[i].destroy();
        }
        for(var i = 0; i < playerBObjects.length; ++i) {
            if(playerBObjects[i])
                playerBObjects[i].destroy();
        }
        for(var i = 0; i < timers.length; ++i) {
            if(timers[i])
                timers[i].destroy();
        }

        playerAObjects = []
        playerBObjects = []
        timers = []
        playerAScore = 0;
        playerBScore = 0;

        var playerAComponents = []
        var playerBComponents = []

        var itemSize = mainWindow.height < mainWindow.width ?
                       mainWindow.height * 0.12:
                       mainWindow.width * 0.12;

        // playerA first line
        for(var i = 0; i < 8; ++i) {
            if(i < 3 || i > 4) {
                playerAComponents = playerAComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerAObjects = playerAObjects.concat(
                        [playerAComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerA + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return mainWindow.height / 3 }),
                            count: 100,
                            owner: Logic.Owner.PlayerA,
                            shipType: Logic.ShipType.JetFighter
                            })]);
                playerAObjects[i].init();
            }
            else {
                playerAComponents = playerAComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerAObjects = playerAObjects.concat(
                        [playerAComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerA + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return mainWindow.height / 3 }),
                            count: 50,
                            owner: Logic.Owner.PlayerA,
                            shipType: Logic.ShipType.HeavyFighter
                            })]);
                playerAObjects[i].init();
            }
        }
        //player A second line
        for(var i = 0; i < 8; ++i) {
            if(i < 2 || i > 5) {
                playerAComponents = playerAComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerAObjects = playerAObjects.concat(
                        [playerAComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerA + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return mainWindow.height / 3 - (mainWindow.height < mainWindow.width ?
                                                                                       mainWindow.height * 0.12:
                                                                                       mainWindow.width * 0.12) - 10  }),
                            count: 30,
                            owner: Logic.Owner.PlayerA,
                            shipType: Logic.ShipType.Cruiser
                            })]);
                playerAObjects[i].init();
            }
            else if(i == 3 || i == 4) {
                playerAComponents = playerAComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerAObjects = playerAObjects.concat(
                        [playerAComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerA + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return mainWindow.height / 3 - (mainWindow.height < mainWindow.width ?
                                                                                       mainWindow.height * 0.12:
                                                                                       mainWindow.width * 0.12) - 10 }),
                            count: 5,
                            owner: Logic.Owner.PlayerA,
                            shipType: Logic.ShipType.Destroyer
                            })]);
                playerAObjects[i].init();
            }
             else {
                playerAComponents = playerAComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerAObjects = playerAObjects.concat(
                        [playerAComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerA + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return mainWindow.height / 3 - (mainWindow.height < mainWindow.width ?
                                                                                       mainWindow.height * 0.12:
                                                                                       mainWindow.width * 0.12) - 10 }),
                            count: 20,
                            owner: Logic.Owner.PlayerA,
                            shipType: Logic.ShipType.Drednot
                            })]);
                playerAObjects[i].init();
            }
        }



        //player B first line
        for(var i = 0; i < 8; ++i) {
            if(i < 3 || i > 4) {
                playerBComponents = playerBComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerBObjects = playerBObjects.concat(
                        [playerBComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerB + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return 2 * mainWindow.height / 3 }),
                            count: 100,
                            owner: Logic.Owner.PlayerB,
                            shipType: Logic.ShipType.JetFighter
                            })]);
                playerBObjects[i].init();
            }
            else {
                playerBComponents = playerBComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerBObjects = playerBObjects.concat(
                        [playerBComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerB + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return 2 * mainWindow.height / 3 }),
                            count: 50,
                            owner: Logic.Owner.PlayerB,
                            shipType: Logic.ShipType.HeavyFighter
                            })]);
                playerBObjects[i].init();
            }
        }
        //playerB second line
        for(var i = 0; i < 8; ++i) {
            if(i < 2 || i > 5) {
                playerBComponents = playerBComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerBObjects = playerBObjects.concat(
                        [playerBComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerB + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                            y: Qt.binding(function() { return 2 * mainWindow.height / 3 + (mainWindow.height < mainWindow.width ?
                                                                                           mainWindow.height * 0.12:
                                                                                           mainWindow.width * 0.12) + 10 }),
                            count: 30,
                            owner: Logic.Owner.PlayerB,
                            shipType: Logic.ShipType.Cruiser
                           })]);
                playerBObjects[i].init();
            }
            else if(i == 3 || i == 4) {
                playerBComponents = playerBComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerBObjects = playerBObjects.concat(
                     [playerBComponents[i].createObject(mainWindow, {
                             identifier: Logic.Owner.PlayerB + i,
                            n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                             y: Qt.binding(function() { return 2 * mainWindow.height / 3 + (mainWindow.height < mainWindow.width ?
                                                                                            mainWindow.height * 0.12:
                                                                                            mainWindow.width * 0.12) + 10 }),
                            count: 5,
                             owner: Logic.Owner.PlayerB,
                             shipType: Logic.ShipType.Destroyer
                             })]);
                playerBObjects[i].init();
            }
             else {
                playerBComponents = playerBComponents.concat([Qt.createComponent("FormationItem.qml")]);
                playerBObjects = playerBObjects.concat(
                        [playerBComponents[i].createObject(mainWindow, {
                            identifier: Logic.Owner.PlayerB + i,
                             n: i,
                            x: Qt.binding(function() { return mainWindow.width / 5 + this.n * ((mainWindow.height < mainWindow.width ?
                                                                                                mainWindow.height * 0.12:
                                                                                                mainWindow.width * 0.12) + 10) }),
                             y: Qt.binding(function() { return 2 * mainWindow.height / 3 + (mainWindow.height < mainWindow.width ?
                                                                                            mainWindow.height * 0.12:
                                                                                            mainWindow.width * 0.12) + 10 }),
                             count: 20,
                             owner: Logic.Owner.PlayerB,
                             shipType: Logic.ShipType.Drednot
                             })]);
                 playerBObjects[i].init();
              }
        }


    } // new game



} // ApplicationWindow
