TUIST = mise exec -- tuist
SWIFTLINT = swiftlint

all: lint build-dev

generate:
	@echo "🔧 Tuist generate 시작..."
	$(TUIST) install
	TUIST_ROOT_DIR=${PWD} $(TUIST) generate
	
lint:
	@echo "🔍 SwiftLint 검사 시작..."
	@$(SWIFTLINT) || echo "⚠️ SwiftLint 실행 실패 (설치 여부 확인)"

format:
	@echo "🛠 SwiftLint 자동 포맷 수행..."
	@$(SWIFTLINT) autocorrect --fix

clean:
	@echo "🧹 Tuist 생성물 정리..."
	find . -type d -name Derived -exec rm -rf {} +
	find . -type d -name "*.xcodeproj" -exec rm -rf {} +
	find . -type d -name "*.xcworkspace" -exec rm -rf {} +
	
help:
	@echo "📝 사용 가능한 명령어:"
	@echo "  make all               - 린트 및 dev 빌드 수행"
	@echo "  make generate          - tuist generate 수행"
	@echo "  make lint              - 코드 린트"
	@echo "  make format            - 코드 자동 포맷팅"
	@echo "  make clean             - Tuist 생성물 모두 삭제"
	@echo "  make help              - 사용 가능한 명령어 목록 출력"
