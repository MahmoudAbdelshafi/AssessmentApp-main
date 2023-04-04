# AssessmentApp

## Run Requirements 
 * IOS14
 * XCode Version 15.0
 
 ## OVERVIEW
  - AssessmentApp is a simple iOS App built using Clean Architecture and MVVM.

## High Level Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces.
* **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB.
* **Presentation Layer (MVVM)** = ViewModels + Views.

## Data Flow
* 1. `View(UI)` calls method from `ViewModel (Presenter)`.
* 2. `ViewModel` executes Use Case.
* 3. `Use Case` combines data from User and Repositories.
* 4. Each Repository returns data from a Remote Data `(Network)`, Persistent DB Storage Source or In-memory Data (Remote or Cached).
* 5. Information flows back to the `View(UI)` where we display the list of items.

## Dependency Direction
* `Presentation Layer` `->` `Domain Layer` `<-` `Data Repositories Layer`
* `Presentation Layer (MVVM)` = `ViewModels(Presenters)` + `Views(UI)`
* `Domain Layer` = `Entities` + `Use Cases` + `Repositories Interfaces`
* `Data Repositories Layer` = `Repositories Implementations` + `API(Network)` + `Persistence DB`


##### Domain Layer
* It contains Entities, FetchProductsUseCase which fetches the products data.
* it contains Data Repositories Interfaces which are needed for Dependency Inversion.


##### Presentation Layer
* Containts the MainController with products data that are observed from the MainViewModel.

**`ViewModel`** Contains the view controller business logic apstracted with INPUT and OUTPUT Protocol.
* `Note` UI cannot have access to business logic or application logic (Business Models and UseCases), only ViewModels can do it. This is the separation of concerns. We cannot pass business models directly to the View (UI). This why we are mapping Business Models into ViewModel inside ViewModel and pass them to the View.

* Containts Flow `Coordinator` for presentation logic.
* `Note` Flow Coordinator for presentation logic, to reduce View Controllers’ size and responsibility.


##### Data Layer
* Contains `Repositories` Implementaion, It conforms to interfaces defined inside Domain Layer.
* `Note`  Data Layer conforms to interfaces defined inside Domain Layer in order to achieve (Dependency Inversion).

* Contains the `DTO` and mapping objects.
* `Note` Data Transfer Objects DTO is used as intermediate object for mapping from JSON response into Domain. Also for mapping data to the persistent storage.


##### Infrastructure Layer (Network)

* **`Service / Networking`** - contains the Router enum that is responsible for the apis structure.
* `Endpoint` - contains the BasAPI singleton class which contains the genaric base api request.
* `Encoding` - contains the all the necessarily encoding methods for building the urls.


