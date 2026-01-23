package org.example.crossplatformshowcase.kmp.domain.exceptions

sealed class AppException(messageLocKey: String) : Exception(messageLocKey) {
    // TODO: to localize
    fun toMessage(): String = this.message ?: ""
}

class NetworkException(messageLocKey: String = "error.networkUnavailable") :
    AppException(messageLocKey) {}

class NotFoundException(messageLocKey: String = "error.notFound") : AppException(messageLocKey) {}

class ServerException(messageLocKey: String = "error.server") : AppException(messageLocKey) {}
