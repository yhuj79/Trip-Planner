# Trip-Planner

<img align=top src="https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/thumbnail.png" width="600">

관광지 정보 확인 및 여행 일정 관리 앱

:ballot_box_with_check: <a target="_blank" rel="noopener noreferrer" href="https://www.youtube.com/watch?v=sGLzotkoGf4">시연 영상</a>

## Built With

<p>
  <img alt="Swift" src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=swift&logoColor=white" height=25 />
  <img alt="Apple_Maps" src="https://img.shields.io/badge/Apple_Maps-FFFFFF?style=flat&logo=apple&logoColor=000000" height=25 />
  <img alt="MySQL" src="https://img.shields.io/badge/MySQL-blue?style=flat&logo=mysql&logoColor=white" height=25 />
  <img alt="Express" src="https://img.shields.io/badge/Express-gold?style=flat&logo=express&logoColor=white" height=25 />
</p>

## About The Project

### :alarm_clock: 제작 기간

- 2023.11.20 ~ 2023.12.04

### :gear: 개발 환경

- XCode 15.0.1, iOS 17
- Visual Studio Code (MySQL: 2.18.1, Express: 4.18.2)

### :clipboard: 주요 적용 사항

#### 탐색 뷰 (ExploreView)

<div>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/explore1.png width=250>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/explore2.png width=250>
</div>

<br>

- 패키지, 관광지, 숙소 리스트를 보여주는 뷰
- 정보 웹페이지 링크, 지도 기능
- 우측 상단 버튼으로 위시리스트 등록/삭제 가능

<br>

#### 위시리스트 뷰 (WishListView)

<div>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/wish1.png width=250>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/wish2.png width=250>
</div>

<br>

- 위시리스트로 등록해 놓은 패키지, 관광지, 숙소 리스트를 보여주는 뷰

<br>

#### 일정 뷰 (PlanView)

<div>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/plan2.png width=250>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/plan1.png width=250>
</div>
<div>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/plan3.png width=250>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/plan4.png width=250>
</div>

<br>

- 숙소와 관광지를 입력하여 하루 플랜을 구성
- 최근접 이웃 알고리즘(Nearest Neighbor Algorithm)을 통해 선택한 관광지 동선을 계산

<br>

#### AI챗 뷰 (ChatView)

<div>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/ai1.png width=250>
    <img align=top src=https://raw.githubusercontent.com/yhuj79/Trip-Planner/main/Assets/ai2.png width=250>
</div>

<br>

- 웹뷰(WebView)를 통해 Google AI Service인 Bard로 연결

<br>

## Reference

[https://docs.swift.org/swift-book/documentation/the-swift-programming-language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language)

[https://developer.apple.com/tutorials/swiftui](https://developer.apple.com/tutorials/swiftui)

[https://blog.devgenius.io/traveling-salesman-problem-nearest-neighbor-algorithm-solution-e78399d0ab0c](https://blog.devgenius.io/traveling-salesman-problem-nearest-neighbor-algorithm-solution-e78399d0ab0c)

[https://www.wikipedia.org](https://www.wikipedia.org)

[https://blog.naver.com/loyz/222379027185](https://blog.naver.com/loyz/222379027185)

[https://develop-const.tistory.com/29](https://develop-const.tistory.com/29)

[https://www.hohyeonmoon.com/blog/swiftui-tutorial-tab-view](https://www.hohyeonmoon.com/blog/swiftui-tutorial-tab-view)

[https://ggasoon2.tistory.com/m/9](https://ggasoon2.tistory.com/m/9)

[https://develop-const.tistory.com/33](https://develop-const.tistory.com/33)

[https://steady-dev.tistory.com/226](https://steady-dev.tistory.com/226)