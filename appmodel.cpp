#include "AppModel.h"
#include <QDir>
#include <QDirIterator>
#include <QSettings>
#include <QStandardPaths>

AppModel::AppModel(QObject *parent) : QAbstractListModel(parent) {
    refresh();
}

void AppModel::refresh() {
    beginResetModel();
    m_apps.clear();

    QStringList dirs = {
        "/usr/share/applications",
        QDir::homePath() + "/.local/share/applications",
        "/var/lib/flatpak/exports/share/applications"
        // add more if needed
    };

    for (const QString &dirPath : dirs) {
        QDir dir(dirPath);
        if (!dir.exists()) continue;

        QDirIterator it(dir.path(), {"*.desktop"}, QDir::Files);
        while (it.hasNext()) {
            QString file = it.next();
            QSettings desktop(file, QSettings::IniFormat);
            desktop.beginGroup("Desktop Entry");

            if (desktop.value("NoDisplay", false).toBool() ||
                desktop.value("Hidden", false).toBool()) {
                continue;  // skip hidden apps
            }

            QString name = desktop.value("Name").toString();
            if (name.isEmpty()) continue;

            AppInfo info;
            info.name    = name;
            info.icon    = desktop.value("Icon").toString();  // can be name or path
            info.exec    = desktop.value("Exec").toString();
            info.comment = desktop.value("Comment").toString();

            m_apps.append(info);
        }
    }


    std::sort(m_apps.begin(), m_apps.end(), [](const AppInfo &a, const AppInfo &b){
        return a.name < b.name;
    });

    endResetModel();
}

int AppModel::rowCount(const QModelIndex &) const { return m_apps.size(); }

QVariant AppModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_apps.size()) return QVariant();

    const AppInfo &app = m_apps.at(index.row());

    switch (role) {
    case NameRole:    return app.name;
    case IconRole:    return app.icon;
    case ExecRole:    return app.exec;
    case CommentRole: return app.comment;
    default: return QVariant();
    }
}

QHash<int, QByteArray> AppModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole]    = "name";
    roles[IconRole]    = "icon";
    roles[ExecRole]    = "exec";
    roles[CommentRole] = "comment";
    return roles;
}