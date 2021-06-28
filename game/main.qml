import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

Window {
    id: w

    visible: true

    minimumWidth: rl.width
    maximumWidth: rl.width
    width: rl.width
    minimumHeight: cl.height
    maximumHeight: cl.height
    height: cl.height

    title: qsTr("Найди слово!")

    RowLayout{
        id: rl

        ColumnLayout {
            id: cl

            anchors.centerIn: rl.contentItem
            spacing: 4

            Gameplay {
                id: gameplay

                onStopTimer: toolbar.stopTimer()
                onCrossOut: {
                    listWords.crossOut(word)
                    toolbar.increase()
                }
                onUpdateWords: listWords.updateWords(words)
            }

            Toolbar {
                id: toolbar

                onNewGame: gameplay.newGame()
                onQuitApp: Qt.quit()
                onTimeIsOver: gameplay.lose()
            }
        }

        Words {
            id: listWords
        }
    }


}
