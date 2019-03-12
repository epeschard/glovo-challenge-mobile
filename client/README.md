# Glovo Take Home Test


## How to use it:
1. Change the ip address [hardcoded here](https://github.com/epeschard/glovo-challenge-mobile/blob/6b680abb620610ccbf7dcd4c0eb83ccf4c7313ef/client/Glovo/Interactor/GlovoAPIClient.swift#L112) to the ip address of your local server.
2. Build and run


### General Notes:
* in this exercise we use a variation of VIPER architecture with Builders.

* the app is separated in **View Scenes**, each one of them having:
    - **View Controller** handling only the on screen presentation;
    - **Interactor** handling the communication with network or realms persistance;
    - **Presenter** handling the presentation logic within the module;
    - **Entities** the whole project uses 2 persistance classes: _Country_ & _City_. These are not scene specific;
    - **Router** handling the flow between modules. There is one main Router, extended by each scene;
    - **Builder** providing an instantiation of the module

* We use Realm's change notification mechanism to read and write data independently and be notified, in real-time, about any changes that occurred. We can then update the UI reactively having a better separation of concerns

* I use case-less enums to provide name-classing extensively throughout the app.

### Issues

* I couldn't get Codable running with Realm, so ended up modifying the parsing to [use JSONSerialization](https://realm.io/docs/swift/latest#json) instead of Codable;

* The tests where prepared to use Codable and couldn't manage to fix them on-time :(;

### Next steps

* Fix the testing of Networking and persistance using Realm

* Add Snapshot tests for Scene

* Remove UIKit from Router in order to add MacOS acceptance tests for the app's flow as presented by [Remix architecture](https://github.com/dcutting/Remix)

* While extracting the communication between scenes to the Router, I ended up with the CityInfo card being added twice
