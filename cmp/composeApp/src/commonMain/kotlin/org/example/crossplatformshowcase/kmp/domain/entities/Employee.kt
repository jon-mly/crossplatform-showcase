package org.example.crossplatformshowcase.kmp.domain.entities

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// entity takes the DTO role as well for simplification
// TODO: split with DTO if required

@Serializable
data class Employee(
    val id: Int?,
    @SerialName("employee_name") val employeeName: String?,
    @SerialName("employee_salary") val employeeSalary: Int?,
    @SerialName("employee_age") val employeeAge: Int?,
    @SerialName("profile_image") val profileImage: String?
) {
    val isPending: Boolean
        get() = id == null
}