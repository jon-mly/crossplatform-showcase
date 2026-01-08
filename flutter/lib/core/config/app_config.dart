class AppConfig {
  AppConfig._({
    required this.useMockApi,
    required this.appName,
    required this.employeesApiBaseUrl,
  });

  final bool useMockApi;
  final String appName;
  final String employeesApiBaseUrl;

  factory AppConfig.prod() {
    return AppConfig._(
      useMockApi: false,
      appName: "Employees App Prod",
      employeesApiBaseUrl: 'https://dummy.restapiexample.com/api/v1',
    );
  }

  factory AppConfig.dev() {
    return AppConfig._(
      useMockApi: true,
      appName: "Employees App Dev",
      employeesApiBaseUrl: 'https://dummy.restapiexample.com/api/v1',
    );
  }
}
