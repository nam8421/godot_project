# Godot Pokemon Project

이 프로젝트는 Godot Engine 4.x 버전으로 제작된 포켓몬스터 팬 게임입니다.

## 실행 방법

1. **Godot Engine 4.x 다운로드**
   - [공식 홈페이지](https://godotengine.org/download)에서 OS에 맞는 버전을 다운로드합니다. (Standard 버전 추천)

2. **프로젝트 가져오기 (Import)**
   - Godot 엔진을 실행합니다.
   - 프로젝트 관리자 화면에서 `Import` 버튼을 클릭합니다.
   - `godot_project` 폴더 안에 있는 `project.godot` 파일을 선택합니다.
   - `Import & Edit`을 클릭합니다.

3. **게임 실행**
   - 에디터 우측 상단의 `▶` 버튼(Play Project)을 누르거나 `F5` 키를 누르면 게임이 시작됩니다.

## 프로젝트 구조

- `scenes/`: 게임의 각 화면(Scene) 파일 (`.tscn`)
  - `Main.tscn`: 게임 시작점 (Scene 관리)
  - `Title.tscn`: 타이틀 화면 (스타터 선택)
  - `Explore.tscn`: 메인 메뉴 (배틀, 회복, 도감 이동)
  - `Battle.tscn`: 포켓몬 배틀 화면
  - `Pokedex.tscn`: 포켓몬 도감 화면
- `scripts/`: 게임 로직 (`.gd`)
  - `PokemonData.gd`: 포켓몬 DB (Autoload)
  - `Global.gd`: 전역 상태 관리 (Autoload)
  - `Pokemon.gd`: 포켓몬 객체 클래스
- `assets/`: 이미지 리소스

## 주요 기능

- **타이틀**: 스타터 포켓몬(파이리, 꼬부기, 이상해씨, 피카츄) 선택
- **탐험**: 내 포켓몬 확인, 배틀 진입, 회복
- **배틀**: 턴제 배틀 시스템 구현 (공격, 명중률, 타입 상성, 크리티컬 적용)
- **도감**: 151마리 포켓몬 리스트 및 상세 정보 확인

## 개발자 노트

- 이 프로젝트는 Python(Pygame) 프로젝트에서 마이그레이션 되었습니다.
- 대부분의 로직은 `scripts/` 폴더 내에 GDScript로 포팅되었습니다.
