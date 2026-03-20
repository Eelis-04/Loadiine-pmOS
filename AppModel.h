// AppModel.h
#pragma once
#include <QAbstractListModel>
#include <QStringList>
class AppModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum AppRoles {
        NameRole = Qt::UserRole + 1,
        IconRole,
        ExecRole,
        CommentRole
    };

    explicit AppModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();

private:
    struct AppInfo {
        QString name;
        QString icon;
        QString exec;
        QString comment;
    };
    QList<AppInfo> m_apps;
};