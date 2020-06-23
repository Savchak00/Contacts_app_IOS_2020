# Contacts

1) MainViewController: переключатель с UITableView на UICollectionView
2) DetailViewControler: Вызывается при нажатии на ячейку, показывает данные о выбранной ячейке. Для него реализован кастомный переход.
3) UI полностью построен в коде
4) Реализована архитектура MVP: Файл Builder создает window?.rootViewController в SceneDelegate
5) Информация о пользователях формируется рандомно в ContactsPresenter, фотографии приходят с gravatar по почте.
6) Simulate changes button - рандомно перетусовывает данные, удаляя часть и создавая новые.


