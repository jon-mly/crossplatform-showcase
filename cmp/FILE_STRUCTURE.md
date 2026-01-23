composeApp/src/
├── commonMain/kotlin/com/yourpackage/
│   │
│   ├── core/
│   │   ├── config/
│   │   │   └── AppConfig.kt              # Environment configuration (dev/prod)
│   │   ├── network/
│   │   │   ├── HttpClientFactory.kt      # Ktor client setup with retry
│   │   │   └── NetworkException.kt       # Network-specific exceptions
│   │   ├── database/
│   │   │   └── DatabaseFactory.kt        # expect declaration for SQLDelight driver
│   │   └── di/
│   │       ├── CoreModule.kt             # Koin module for core dependencies
│   │       └── AppModule.kt              # Root Koin module aggregating all modules
│   │
│   ├── domain/
│   │   ├── model/
│   │   │   ├── Employee.kt               # Data class with @Serializable
│   │   │   ├── EmployeeEdit.kt
│   │   │   └── SyncData.kt               # Sealed class for sync state
│   │   ├── repository/
│   │   │   ├── EmployeesRepository.kt    # Interface (contract)
│   │   │   └── EmployeesPersistenceRepository.kt
│   │   ├── service/
│   │   │   └── EmployeeService.kt        # Business logic, injected with repositories
│   │   ├── exception/
│   │   │   └── AppException.kt           # Sealed class for domain exceptions
│   │   └── di/
│   │       └── DomainModule.kt           # Koin module for services
│   │
│   ├── data/
│   │   ├── remote/
│   │   │   ├── dto/                      # If you add DTOs later
│   │   │   │   └── EmployeeDto.kt
│   │   │   ├── EmployeesRepositoryImpl.kt
│   │   │   └── EmployeesRepositoryMock.kt
│   │   ├── local/
│   │   │   └── EmployeesPersistenceRepositoryImpl.kt
│   │   └── di/
│   │       └── DataModule.kt             # Koin module for repositories
│   │
│   ├── presentation/
│   │   ├── navigation/
│   │   │   └── AppNavigation.kt          # Voyager or Decompose setup
│   │   ├── theme/
│   │   │   ├── Theme.kt                  # MaterialTheme configuration
│   │   │   ├── Color.kt
│   │   │   ├── Typography.kt
│   │   │   └── Spacing.kt                # Design tokens
│   │   ├── components/                   # Reusable composables
│   │   │   ├── LoadingIndicator.kt
│   │   │   ├── ErrorView.kt
│   │   │   └── SyncStatusChip.kt
│   │   ├── employees/
│   │   │   ├── list/
│   │   │   │   ├── EmployeesListScreen.kt
│   │   │   │   └── EmployeesListViewModel.kt
│   │   │   ├── detail/
│   │   │   │   ├── EmployeeDetailScreen.kt
│   │   │   │   └── EmployeeDetailViewModel.kt
│   │   │   └── edit/
│   │   │       ├── EmployeeEditDialog.kt
│   │   │       └── EmployeeEditViewModel.kt
│   │   └── di/
│   │       └── PresentationModule.kt     # Koin module for ViewModels
│   │
│   └── App.kt                            # Root composable, Koin init
│
├── androidMain/kotlin/com/yourpackage/
│   ├── core/
│   │   └── database/
│   │       └── DatabaseFactory.android.kt  # actual SQLDelight driver
│   ├── MainActivity.kt
│   └── MainApplication.kt                  # Koin startKoin() for Android
│
├── iosMain/kotlin/com/yourpackage/
│   ├── core/
│   │   └── database/
│   │       └── DatabaseFactory.ios.kt      # actual SQLDelight driver
│   ├── MainViewController.kt
│   └── KoinHelper.kt                       # Helper to init Koin from Swift
│
└── commonTest/kotlin/com/yourpackage/
├── domain/
│   └── service/
│       └── EmployeeServiceTest.kt
└── data/
└── EmployeesRepositoryTest.kt