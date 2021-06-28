import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RowLayout {

    signal newGame()
    signal quitApp()
    signal timeIsOver()

    property int words: 0

    // останавливает таймер при завершении игры
    function stopTimer() {
        gametimer.end = false
    }

    // устанавливает время в начале игры
    function setTime() {
        gametimer.setTime()
    }

    // увеличивает количество найденных слов
    function increase(){
        words++
    }

    // обнуляет количество найденных слов
    function resetCounter() {
        words = 0
    }

    Rectangle {
        id: newGameButton
        color: "black"
        Layout.fillWidth: true
        height: 40

        TextInput {
            font.pointSize: 14

            text:  "Новая игра"
            color: "white"
            anchors.centerIn: parent
            horizontalAlignment: TextInput.AlignHCenter
            readOnly: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                newGame()
                gametimer.setTime()
                resetCounter()
            }
        }
    }

    Rectangle {
        color: "black"
        height: 40
        Layout.fillWidth: true
        TextInput {
            id: gametimer

            anchors.centerIn: parent
            horizontalAlignment: TextInput.AlignHCenter
            font.pointSize: 16
            readOnly: true
            text: timeString
            color: "white"

            property int timeNum        // время в секундах
            property string timeString  // время строкой
            property bool end: false    // идёт ли отсчёт?
            property int a              // вспомогательная переменная для преобразования времени из целого числа секунд в строку

            function setTime() {
                timeNum = 600
                end = true
                timeString = "10:00"
            }

            function time() {
                timeNum--
                a = timeNum / 60
                if ((timeNum % 60) < 10)
                    timeString = `${a}:0${timeNum % 60}`
                else
                    timeString = `${a}:${timeNum % 60}`
                if (timeNum === 0) {
                    end = false;
                    timeIsOver()
                }
            }

            Timer {
                interval: 1000
                repeat: true
                running: gametimer.end
                onTriggered: gametimer.time()
            }
        }
    }

    Rectangle {
        color: "black"
        Layout.fillWidth: true
        height: 40
        TextInput {
            anchors.centerIn: parent
            horizontalAlignment: TextInput.AlignHCenter
            font.pointSize: 16
            color: "white"
            readOnly: true
            text: `${words}/15`
        }
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequences: ["Ctrl+N"]
        onActivated: newGame()
    }

    Shortcut {
        context: Qt.ApplicationShortcut
        sequences: [StandardKey.Close, "Ctrl+Q"]
        onActivated: quitApp()
    }

    Component.onCompleted: {
        gametimer.setTime()
    }
}
