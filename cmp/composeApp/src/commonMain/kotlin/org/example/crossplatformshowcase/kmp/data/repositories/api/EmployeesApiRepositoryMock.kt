package org.example.crossplatformshowcase.kmp.data.repositories.api

import kotlinx.coroutines.delay
import org.example.crossplatformshowcase.kmp.domain.entities.Employee
import org.example.crossplatformshowcase.kmp.domain.entities.EmployeeEdit
import org.example.crossplatformshowcase.kmp.domain.exceptions.NotFoundException
import org.example.crossplatformshowcase.kmp.domain.repositories.api.EmployeesApiRepository
import kotlin.time.Duration
import kotlin.time.Duration.Companion.seconds

class EmployeesApiRepositoryMock : EmployeesApiRepository {

    private val mockEmployees: MutableList<Employee> = mutableListOf(
        Employee(
            id = 1,
            employeeName = "John Doe",
            employeeSalary = 10000,
            employeeAge = 30,
            profileImage = ""
        ),
        Employee(
            id = 2,
            employeeName = "Jane Foo",
            employeeSalary = 20000,
            employeeAge = 40,
            profileImage = ""
        ),
        Employee(
            id = 3,
            employeeName = "Jim Bar",
            employeeSalary = 30000,
            employeeAge = 50,
            profileImage = ""
        ),
    )

    private var lastUserId = 3

    override suspend fun getAllEmployees(): List<Employee> {
        delay(3.seconds)
        return mockEmployees
    }

    override suspend fun createEmployee(employeeEdit: EmployeeEdit) {
        delay(3.seconds)
        lastUserId++
        val newEmployeeId: Int = lastUserId
        mockEmployees.add(
            Employee(
                id = newEmployeeId,
                employeeName = employeeEdit.name,
                employeeSalary = employeeEdit.salary,
                employeeAge = employeeEdit.age,
                profileImage = ""
            )
        )
    }

    override suspend fun updateEmployee(
        id: Int,
        employeeEdit: EmployeeEdit
    ) {
        delay(3.seconds)
        val employeeIndex: Int = mockEmployees.indexOfFirst { e -> e.id == id }
        if (employeeIndex < 0) {
            throw NotFoundException()
        }
        mockEmployees[employeeIndex] = mockEmployees[employeeIndex].copy(
            employeeName = employeeEdit.name,
            employeeSalary = employeeEdit.salary,
            employeeAge = employeeEdit.age,
        )
    }

    override suspend fun deleteEmployee(id: Int) {
        TODO("Not yet implemented")
    }

}