# ☀️ WeatherToday
OpenWeatherMap API를 활용한 날씨 검색 어플리케이션

### 1️⃣ 구현 화면
|메인|목록|검색|
|---|---|---|
|![](https://i.imgur.com/tOaoRh5.jpg)|![](https://i.imgur.com/5oYadCj.png)|![](https://i.imgur.com/Sb4RGva.png)|

### 2️⃣ 기술 스택
- Library: Alamofire, SnapKit, MapKit
- Data/Event: RxSwift, RxCocoa
- Architecture: MVVM with Clean Architecture
- Dependency Manager: CocoaPods

### 3️⃣ Directory Tree
```
├─── WeatherToday
    ├── Presentation
    │   ├── View
    │   │   ├── Main
    │   │   ├── SearchLocation
    │   │   │   ├── View
    │   │   │   │   └── Cell
    │   │   │   └── ViewModel
    │   │   └── CurrentWeather
    │   │       ├── View
    │   │       │   └── Cell
    │   │       └── ViewModel
    │   └── Protocol
    ├── Domain
    │   ├── UseCase
    │   └── Entity
    ├── Data
    │   ├── Repository
    │   └── Network
    │       └── NetworkDTO
    ├── DelegateProxy
    │   └── CLLocationManager
    ├── Extension
    ├── Application
    └── Resource
```
