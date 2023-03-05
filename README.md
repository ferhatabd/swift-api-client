# swift-api-client
An Alamofire wrapper with well defined routes using Swift Concurrency APIs
# Api Client

A wrapper around `Alamofire` that leverages Swift concurrency APIs
App routes can be configured as enums inside the `AppRoute` package with any parameters that are required. 
These routes can then be called from an async scope fully parameterized, optionally decoding the response into a `Decodable` model. 

```
try await apiClient.apiRequest(route: .profile(.block(id: user.id)))
```

```
let response = try await apiClient.apiRequest(route: .account(.get), as: AccountSettingsResponse.self)
```
