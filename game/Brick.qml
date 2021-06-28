import QtQuick 2.12

Rectangle {
    width: 40; height: 40

    property int config // 0 - невыделенная клетка
                        // 1 - клетка найденного слова,
                        // 2 - выделенная пользователем клетка,
                        // 3 - клетка ненайденного слова при проигрыше
    property string letter  // буква в клетке
    property bool needed // является ли клетка частью слова

    color: {
        if (config === 0)
            "#FFF8DC"
        else if (config === 1)
            "lightgreen"
        else if (config === 2)
            "lightblue"
        else "red"
    }
    border.width: 1
    border.color: "black"

    // если пользователь нажал на клетку, меняем её цвет, если это не клетка уже найденного слова
    signal selected()
    function select() {
        if (config === 0) {
            config = 2
            selected()
        } else if (config === 2) {
            config = 0
            selected()
        }
    }

    Text {
        id: txt
        text: `${parent.letter}`
        anchors.centerIn: parent
        font.pointSize: 20
        visible: true
    }


    MouseArea {
        id: click
        anchors.fill: parent

        // по щелчку левой кнопкой идет обработка мыши, если игра еще не закончилась
        onClicked: {
            if ((mouse.button & Qt.LeftButton) && (!gl.stop))
                select()
        }
    }
}
