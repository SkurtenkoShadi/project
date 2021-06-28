import QtQuick 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    // заполняет список словами в начале новой игры
    function updateWords(listWords) {
        for (var i = 0; i < words.count; i++) {
            words.itemAt(i).word = listWords[i];
            words.itemAt(i).found = false;
        }
    }

    // вычеркивает слово при нахождении
    function crossOut(word) {
        for (var i = 0; i < words.count; i++) {
            if (words.itemAt(i).word === word)
               words.itemAt(i).found = true;
        }
    }

    Repeater {
        id: words
        model: 15

        Rectangle {
            property string word
            property bool found

            width: 250
            height: 40

            TextInput {
                text: `${parent.word}`
                font.pointSize: 14
                font.strikeout: parent.found
                anchors.centerIn: parent
                horizontalAlignment: TextInput.AlignHCenter
                readOnly: true
            }
        }
    }
}



