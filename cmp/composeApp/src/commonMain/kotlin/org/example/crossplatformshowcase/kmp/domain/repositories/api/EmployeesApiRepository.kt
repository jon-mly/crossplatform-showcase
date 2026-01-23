package org.example.crossplatformshowcase.kmp.domain.repositories.api

import org.example.crossplatformshowcase.kmp.domain.entities.Employee
import org.example.crossplatformshowcase.kmp.domain.entities.EmployeeEdit

interface EmployeesApiRepository {
    suspend fun getAllEmployees(): List<Employee>
    suspend fun createEmployee(employeeEdit: EmployeeEdit)
    suspend fun updateEmployee(id: Int, employeeEdit: EmployeeEdit)
    suspend fun deleteEmployee(id: Int)
}