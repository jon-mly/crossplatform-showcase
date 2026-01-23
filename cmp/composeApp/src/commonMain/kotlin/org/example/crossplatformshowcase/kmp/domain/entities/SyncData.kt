package org.example.crossplatformshowcase.kmp.domain.entities

enum class DataSource {
    UNSYNCED, SYNCED;

    val locKey: String
        get() = when (this) {
            UNSYNCED -> "dataSource.unsynced"
            SYNCED -> "dataSource.synced"
        }
}

data class SyncData<T>(
    val data: T,
    val source: DataSource,
)
