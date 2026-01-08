enum DataSource {
  unsynced,
  synced;

  String get locKey => switch (this) {
    .unsynced => 'dataSource.unsynced',
    .synced => 'dataSource.synced',
  };
}

class SyncData<T> {
  final T data;
  final DataSource source;

  SyncData({required this.data, required this.source});
}
