import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    property int attack
    property int count
    property int fireRate
    property var target
    property int startX
    property int startY
    property int targetX
    property int targetY
    property int interval


    id: bullet
    border.color: "yellow"
    radius: 50
    color: "yellow"
    height: mainWindow.height / 50
    width: height

    PropertyAnimation {
        id: moveBulletX;
        target: bullet;
        properties: "x";
        from: startX
        to: targetX;
        duration: interval
        loops: Animation.Infinite
    }

    PropertyAnimation {
        id: moveBulletY;
        target: bullet;
        properties: "y";
        from: startY
        to: targetY;
        duration: interval
        loops: Animation.Infinite
    }

    Component.onCompleted: {
        moveBulletX.start()
        moveBulletY.start()
    }

    Timer {
        interval: fireRate
        running: true
        repeat: true

        onTriggered: {
            if(target.hit(attack, count)) {
                target.destroy();
                bullet.destroy();
                destroy();
            }

        }
    }
}



