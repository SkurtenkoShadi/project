#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QVector>

class Helper : public QObject
{
    Q_OBJECT
public:
    explicit Helper(QObject *parent = nullptr);

signals:

public slots:
    QVector<QString> newGame(QVector<QString> words);
    QVector<QString> dictionary();
    QVector<QString> filling(QVector<QString> letters);

};

#endif // HELPER_H
