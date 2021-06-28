import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

GridLayout {
    id: gl

    width: columns * 40
    height: rows * 40

    columns: 30
    rows: 18

    columnSpacing: 0
    rowSpacing: 0    

    property int wordsCount: 15 // количество слов, которые надо найти
    property int guessedWords // количество найденных слов
    property bool win // проиграл ли пользователь
    property bool stop // идет ли игра
    property var words: [ "" ]

    signal stopTimer()
    signal crossOut(var word)
    signal updateWords (var words)

    // инициализирует новую игру
    function newGame() {
        for (var i = 0; i < bricks.count; i++) {
            bricks.itemAt(i).config = 0
            bricks.itemAt(i).needed = false;
        }
        win = true
        stop = false
        guessedWords = 0
        words = helper.dictionary()
        updateWords(words)
        var letters = helper.newGame(words);
        for (i = 0; i < bricks.count; i++)
            if (letters[i] !== '-') {
                bricks.itemAt(i).needed = true;
            }
        letters = helper.filling(letters);
        for (i = 0; i < bricks.count; i++)
            bricks.itemAt(i).letter = letters[i];
    }

    // проверяет, все ли слова найдены
    function checkWin() {
        if (guessedWords === wordsCount) {
            stopTimer()
            win = true
            dialog.open()
            stop = true
        }
    }

    // при проигрыше останавливает игру и подсвечивает ненайденные слова
    function lose() {
        win = false
        stop = true

        for (var i = 0; i < bricks.count; i++) {
            if (bricks.itemAt(i).needed)
                if (bricks.itemAt(i).config !== 1)
                    bricks.itemAt(i).config = 3
        }
        dialog.open()
    }

    // проверяет, совпадают ли выделенные пользователем клетки со словом
    function checkWord() {
        var word = []
        var flag = false
        for (var i = 0; i < bricks.count; i++) {
            if (bricks.itemAt(i).config === 2)
                if(bricks.itemAt(i).needed)
                    word.push(bricks.itemAt(i).letter)
                else {
                    flag = true;
                    break;
                }
        }
        if (!flag) {
            word.sort()
            var symbols
            for (i = 0; i < words.length; i++) {
                symbols = (words[i].split("")).sort()
                if (arrayCompare(word, symbols)){
                    guessedWords++
                    checkWin()
                    crossOut(words[i])
                    for (i = 0; i < bricks.count; i++) {
                        if (bricks.itemAt(i).config === 2)
                            bricks.itemAt(i).config = 1
                    }
                }
            }
        }
    }

    // сравнивает два массива
    function arrayCompare(a, b)
    {
        if(a.length !== b.length)
           return false;

        for(var i = 0; i < a.length; i++)
           if(a[i] !== b[i])
              return false;

        return true;
    }

    Repeater {
        id: bricks
        model: parent.columns * parent.rows

        Brick {
            onSelected: {
                checkWord()
            }
        }
    }

    Dialog {
        id: dialog
        height: 100
        width: 400
        title: " "
        contentItem: Rectangle {
            Text {
                text: win ? "ВЫ ВЫИГРАЛИ!" : "ВЫ ПРОИГРАЛИ!"
                anchors.centerIn: parent
                font.pointSize: 25
            }
        }
    }

    Component.onCompleted: {
        newGame()
    }
}
