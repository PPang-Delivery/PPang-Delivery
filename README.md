# 빵딜

## 🍎 App Icon
<img width="100" height="100" src="https://user-images.githubusercontent.com/50796114/202826080-eb31190b-460a-42a5-9121-11fba29f90af.png">

#### 빵원 딜리버리, 빵딜

## 🤝 Introduction
 - 배달비의 부담이 커져만 가는 요즘, 주변사람들과 빵딜해요!

## 🧩 Functions
```
1. 이용자가 같이 배달을 시키고 싶은 메뉴와 장소를 정하면, 지도에 음식종류의 pin이 해당 장소에 약간의 정보와 함께 생성됩니다.
2. 다른 이용자는 지도에 생성된 pin들을 통해 같이 배달할 장소와 음식 종류를 알 수 있습니다.
3. 원하는 pin을 선택하게 되면 pin을 생성한 이용자의 채팅방에 입장하며, 채팅을 통해 각자 시킬 메뉴를 정하고 배달합니다.
4. 같이 배달만 하고 헤어지기 아쉽다면, 한강공원같은 곳에서 같이 먹을 사람을 찾는건 어떨까요?!
```

## 📸 Screenshots
|Map View|Search Func|PopUp View|Chat View|Profile View|
|---|---|---|---|---|
|<img width="150" height="300" alt="Map View" src="https://user-images.githubusercontent.com/50796114/203492967-942c3b0c-a198-48d5-ac62-7f12aa40754c.png">|<img width="150" height="300"  alt="Search Func" src="https://user-images.githubusercontent.com/50796114/203494527-84cd37df-e5c3-4bc9-902c-0e2d29d465ef.gif">|<img width="150" height="300"  alt="Popup View" src="https://user-images.githubusercontent.com/50796114/203505709-df10085e-c419-45f6-b01f-e45be5b1ae21.png">|<img width="150" height="300"  alt="Chat View" src="https://user-images.githubusercontent.com/50796114/203493265-173ce87c-c9a6-42cc-8bed-0a48befc2116.gif">|<img width="150" height="300"  alt="Profile View" src="https://user-images.githubusercontent.com/50796114/203493169-4a111096-1384-462f-a1ea-cb6680771b67.png">|

## 🛠Development Environment
![Generic badge](https://img.shields.io/badge/iOS-15.0+-lightgrey.svg) ![Generic badge](https://img.shields.io/badge/Xcode-13.0-blue.svg)

## ⚙️ Tools
```
1. Github (이슈 및 형상 관리)
2. Notion (커뮤니케이션)
3. Xcode (개발)
```

## ✨ Skills & Tech Stack
```
 - UIKit (Codebase)
 - Firebase (Firestore & Firebase Realtime DB)
 - Naver Map SDK
 - Snapkit
 - Then
 - Apple Sign In 
 - Google Sign In
 ...
 ```

## 🔀 GIT

1. Commit 컨벤션
    - `feat` : 새로운 기능 추가
    - `fix` : 기능 수정
    - `docs` : 문서 / 개발 외 파일 수정 및 추가
    - `refact` : 코드 리팩토링
    - `style` : 코드 의미에 영향 없는 변경 및 수정.
    - `test` : 테스트 코드 추가 / 정규 업데이트가 아닌 테스트 코드 추가의 경우.

2. Git 브랜치
    - `master` : 배포
    - `develop` : 개발된 기능을 병합하는 브랜치
    - `#[Tracker ID] [Commit Convention Name] / [Function Name]` : 각 기능별 개발을 진행하는 브랜치

## 🗂 Directory Structure
```
PPangDelivery
  |
  └── PPangDelivery
          |── Model
          │   └── PlaceModel
          |── Main
          │   └── MainViewController
          └── Map
          │   │── MapViewController
          │   │── PopUpViewController
          │   └── UIViewController
          |── Chat
          │   │── ChatCollectionViewController
          │   │── ChatMessageCell
          │   │── ChatViewController
          │   │── ConversationTableViewCell
          │   │── ConversationsViewController
          │   │── DataManager
          │   │── Extensions
          │   │── MessageInputView
          │   └── StorageManager
          |── Profile
          │   └── ProfileViewController
          |── Home
          │   └── HomeViewController
          |── Utils
          │   │── UIViewController+Utils
          │   │── UIColor+Utils
          │   └── FirFirestore+Utils
          |── Resource
          │   │── AppDelegate
          │   └── SceneDelegate
          └── Files
              │── Assets
              │── Info.plist
              └── GoogleService-Info.plist
```

## 🧑‍💻 Authors
[Chanheki](https://github.com/chanhihi)   
[Junyoo](https://github.com/JJunghyunY)   
[Kyujlee](https://github.com/dq-QQQ)   
[Sji](https://github.com/JeeeeSangRyul)   
[Sma](https://github.com/sma96)
