#include "helper.h"
#include <cstdlib>
#include <ctime>
#include <QDebug>
#include <QFileDialog>

QVector<QString> generate(QVector<QString> letters, QString word);
int transWidth(int n);
int transHeight(int n);

Helper::Helper(QObject *parent) : QObject(parent)
{

}

// генерирует список слов
QVector<QString> Helper::dictionary() {
    QFile inFile(":/dictionary/words.txt");

    inFile.open(QIODevice::ReadOnly);
    QTextStream in(&inFile);

    int wordsCount = 15;
    srand(time(0));
    int counts[15];

    while (1) {
        for (int i = 0; i < wordsCount; i++)
            counts[i] = rand() % 1000;

        bool flag = false;

        for (int i = 0; i < wordsCount - 1; i++) {
            for (int j = i + 1; j < wordsCount; j++)
                if (counts[i] == counts[j]) {
                    flag = true;
                    break;
                }
            if (flag)
                break;
        }

        if (flag)
            continue;

        int temp; // временная переменная для обмена элементов местами

        // Сортировка массива пузырьком
        for (int i = 0; i < wordsCount - 1; i++) {
            for (int j = 0; j < wordsCount - i - 1; j++) {
                if (counts[j] > counts[j + 1]) {
                    // меняем элементы местами
                    temp = counts[j];
                    counts[j] = counts[j + 1];
                    counts[j + 1] = temp;
                }
            }
        }

        break;
    }

    QVector<QString> words;

    QString line;

    int number_line = 0; // номер текущей строки словаря
    int k = 0; // сколько слов мы уже достали из словаря
    while (k < wordsCount)
    {
        line = in.readLine();
        if (number_line == counts[k]) {
            words.append(line.toUpper());
            k++;
        }
        number_line++;
    }

    return words;
}

// расставляет буквы слов по клеткам
QVector<QString> Helper::newGame(QVector<QString> words)
{
    int wordsCount = 15;

    int cells;

    cells = 30 * 18;

    QVector<QString> letters(cells, "-");

    for (int i = 0; i < wordsCount; i++) {
        letters = generate(letters, words[i]);
    }

    return letters;
}

QVector<QString> generate(QVector<QString> letters, QString word)
{
    int cells, columns, rows;

    columns = 30;
    rows = 18;
    cells = columns * rows;

    srand(time(0));
    int l = word.length();

    while (1) {
        int j = rand() % cells; //ячейка
        int n = rand() % 8; //направление
        bool flag = false;

        if ((j % columns + transWidth(n)*(l - 1) < 0)
                || (j % columns + transWidth(n)*(l - 1) >= columns)
                || (j / columns + transHeight(n)*(l - 1) < 0)
                || (j / columns + transHeight(n)*(l - 1) >= rows))
            flag = true;
        else {
            for (int i = 0; i < l; i++) {
                if (letters[j + transWidth(n)*i + transHeight(n)*i*columns] != "-"){ //клетка уже занята
                    flag = true;
                    break;
                }
            }
        }

        if (flag)
            continue;
        else {
            for (int i = 0; i < l; i++)
                 letters[j + transWidth(n)*i + transHeight(n)*i*columns] = word[i];
            break;
        }

    }

    return letters;
}

int transWidth(int n){
    if (n == 0 || n == 1)
        return 0;
    if (n == 2 || n == 5 || n == 6)
        return -1;
    return 1;
}

int transHeight(int n){
    if (n == 2 || n == 3)
        return 0;
    if (n == 0 || n == 4 || n == 5)
        return -1;
    return 1;
}

// заполняет оставшиеся клетки рандомными буквами
QVector<QString> Helper::filling(QVector<QString> letters) {
    int cells = 30 * 18;
    QString letter[] = {"А", "Б", "В", "Г", "Д", "Е", "Ж", "З", "И",
                           "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С",
                           "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ",
                           "Ы", "Ь", "Э", "Ю", "Я"};
    for (int i = 0; i < cells; i++)
        if (letters[i] == "-") {
            letters[i] = letter[rand() % 32];
        }

    return letters;
}
