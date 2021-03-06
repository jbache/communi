/*
* Copyright (C) 2008-2011 J-P Nurmi jpnurmi@gmail.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*/

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "trayicon.h"

class QDBusInterface;
class MainTabWidget;
struct Connection;
class QAction;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget* parent = 0);
    ~MainWindow();

    QSize sizeHint() const;

public slots:
    void connectTo(const QString& host = QString(), quint16 port = 6667,
                   const QString& nick = QString(), const QString& password = QString());
    void connectTo(const Connection& connection);
    void connectToImpl(const Connection& connection);
    void quit(const QString& message);

protected:
    void closeEvent(QCloseEvent* event);
    void changeEvent(QEvent* event);
    bool event(QEvent* event);

private slots:
    void initialize();
    void trayIconActivated(QSystemTrayIcon::ActivationReason reason);
    void activateAlert(bool activate);
    void activateVibra(bool activate);
    void tabActivated(int index);
    void createWelcomeView();
    void createTabbedView();

private:
    MainTabWidget* tabWidget;
    TrayIcon* trayIcon;
#ifdef Q_WS_MAEMO_5
    QDBusInterface* interface;
    QAction* networksAction;
    QAction* channelsAction;
#endif // Q_WS_MAEMO_5
};

#endif // MAINWINDOW_H
