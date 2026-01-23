package org.example.crossplatformshowcase.kmp.domain.repositories.persistence

import org.example.crossplatformshowcase.kmp.domain.entities.Employee

// TODO: Debate leave persistence in data layer

interface EmployeesPersistenceRepository {
    suspend fun getAllEmployees(): List<Employee>
    suspend fun saveEmployees(employees: List<Employee>)
    suspend fun saveEmployeeAt(index: Int)
}