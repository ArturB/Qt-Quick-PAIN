import QtQuick 2.0
import "XorGameQuick.js" as Logic

Rectangle {
    id: fi

    property double size: 0.12
    property int shipType
    property int count
    property string owner
    property bool selected: false
    property string identifier

    property int n

    property var shipParams: Logic.shipByType(shipType, owner)
    property var ships: []

    //initialize array of formation ships
    function init() {
        ships = []
        for(var i = 0; i < count; ++i) {
            ships = ships.concat(Logic.shipByType(shipType, owner))
        }
    } // init

    // hit formation
    // return true if formation is destroyed
    function hit(attack, count){
        for(var i = 0; i < count; ++i) {
            if(Math.random() * 1000 < shipParams.range) { // chance of hit
                var s = Math.round(Math.random() * (ships.length - 1));
                var isDeleted = ships[s].hit(attack);
                if(isDeleted) {
                    ships.splice(s, 1);
                    if(ships.length == 0) {
                        return true;
                    }
                }
            }
        }
        countText.text = ships.length
        return false;
    } // hit

    Image {
        id: jetfighter
        source: Logic.shipByType(shipType, owner).imgSrc
        width: parent.width - parent.border.width * 2
        height: parent.height - parent.border.width * 2
        anchors.centerIn: parent
        z: parent.z
    }
    height: parent.height < parent.width ? parent.height * size : parent.width * size
    width: height
    border.color: selected ? "red" : "green"
    border.width: 2
    Drag.active: mouseArea.drag.active
    Drag.dragType: Drag.Automatic

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: parent
        onClicked: {
            //clicked player A - hits from player B or selection change of player A
            if(owner === Logic.Owner.PlayerA) {
                var BSelected = []
                for(var i = 0; i < mainWindow.playerBObjects.length; ++i) {
                    if(mainWindow.playerBObjects[i].selected) {
                        BSelected = BSelected.concat([mainWindow.playerBObjects[i]]);
                    }
                }
                //if any of enemy ships were selected, change selection status
                if(BSelected.length == 0) {
                    selected = !selected;
                }
                //otherwise, start shooting
                else {
                    for(var i = 0; i < BSelected.length; ++i) {
                        var timerComponent = Qt.createComponent("ShootingTimer.qml");
                        var pixelHalfItemSize = mainWindow.height < mainWindow.width
                                ? mainWindow.height * size / 2
                                : mainWindow.width * size / 2;
                        mainWindow.timers = mainWindow.timers.concat(
                                [timerComponent.createObject(BSelected[i], {
                                    attack: BSelected[i].shipParams.attack,
                                    count: BSelected[i].ships.length,
                                    fireRate: BSelected[i].shipParams.fireRate,
                                    target: fi,
                                    startX: pixelHalfItemSize,
                                    startY: pixelHalfItemSize,
                                    targetX: fi.x - BSelected[i].x + pixelHalfItemSize,
                                    targetY: fi.y - BSelected[i].y + pixelHalfItemSize,
                                    interval: fi.shipParams.fireRate
                                    })]);
                    }
                    for(var i = 0; i < mainWindow.playerAObjects.length; ++i) {
                        mainWindow.playerAObjects[i].selected = false;
                    }
                    for(var i = 0; i < mainWindow.playerBObjects.length; ++i) {
                        mainWindow.playerBObjects[i].selected = false;
                    }
                } // start shooting to player A
            } // player A


            //clicked player B - hits from player A or selection change of player B
            else {
                var ASelected = []
                for(var i = 0; i < mainWindow.playerAObjects.length; ++i) {
                    if(mainWindow.playerAObjects[i].selected) {
                        ASelected = ASelected.concat([mainWindow.playerAObjects[i]]);
                    }
                }
                //if any of enemy ships were selected, change selection status
                if(ASelected.length == 0) {
                    selected = !selected;
                }
                //otherwise, start shooting
                else {
                    for(var i = 0; i < ASelected.length; ++i) {
                        var timerComponent = Qt.createComponent("ShootingTimer.qml");
                        var pixelHalfItemSize = mainWindow.height < mainWindow.width
                                ? mainWindow.height * size / 2
                                : mainWindow.width * size / 2;
                        mainWindow.timers = mainWindow.timers.concat(
                                [timerComponent.createObject(ASelected[i], {
                                    attack: ASelected[i].shipParams.attack,
                                    count: ASelected[i].ships.length,
                                    fireRate: ASelected[i].shipParams.fireRate,
                                    target: fi,
                                    startX: pixelHalfItemSize,
                                    startY: pixelHalfItemSize,
                                    targetX: fi.x - ASelected[i].x + pixelHalfItemSize,
                                    targetY: fi.y - ASelected[i].y + pixelHalfItemSize,
                                    interval: fi.shipParams.fireRate
                                    })]);
                    }
                    for(var i = 0; i < mainWindow.playerAObjects.length; ++i) {
                        mainWindow.playerAObjects[i].selected = false;
                    }
                    for(var i = 0; i < mainWindow.playerBObjects.length; ++i) {
                        mainWindow.playerBObjects[i].selected = false;
                    }
                } // start shooting to player B
            } // player B


        } // onClicked

    } // MouseArea

    Rectangle {
        color: "black"
        width: parent.width - parent.border.width * 2
        height: parent.height * 0.2 - parent.border.width
        x: parent.border.width
        y: parent.border.width
        Text {
            id: ownerText
            text: owner
            font.pixelSize: parent.height * 0.9
            color: "white"
            anchors.right: parent.right
        }
    }

    Rectangle {
        color: "black"
        width: parent.width - parent.border.width * 2
        height: parent.height * 0.2 - parent.border.width
        x: parent.border.width
        y: parent.height * 0.8
        Text {
            id: countText
            text: ships.length
            color: "white"
            font.pixelSize: parent.height * 0.9
            anchors.right: parent.right
        }
    }

    Drag.onDragStarted: {
        selected = true
    }
    Drag.onDragFinished: {
        selected = false
    }



}
