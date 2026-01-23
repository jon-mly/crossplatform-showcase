package org.example.crossplatformshowcase.kmp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform