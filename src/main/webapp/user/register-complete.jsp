<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 완료 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome (아이콘 사용을 위해) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <%-- CSS 파일 경로는 실제 프로젝트 구조에 맞게 조정하세요 --%>
    <link href="../resources/css/styles.css" rel="stylesheet">
    <%-- 인라인 스타일 블록 제거됨 --%>
</head>
<body>
    <!-- Navigation (회원가입 폼과 동일한 네비게이션 사용) -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <%-- 홈페이지 링크는 실제 경로로 수정하세요 --%>
            <a class="navbar-brand" href="home.jsp">BOOKHUB</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                         <%-- 실제 링크로 수정하세요 --%>
                        <a class="nav-link" href="#">자료검색</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">이용안내</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">문화행사</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">도서관소개</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                         <%-- 로그인 페이지 링크는 실제 경로로 수정하세요 --%>
                        <a class="nav-link" href="signin.jsp">로그인</a>
                    </li>
                    <li class="nav-item">
                        <%-- 회원가입 페이지 링크는 실제 경로로 수정하세요 --%>
                        <a class="nav-link" href="signup.jsp">회원가입</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <%-- 컨테이너 클래스를 signup.jsp에서 사용하던 것(예: signup-container)으로 변경 --%>
    <%-- 또는 내용에 더 적합한 다른 기존 클래스(예: card, login-container 등) 사용 --%>
    <div class="signup-container text-center mt-5 mb-5"> <%-- text-center 추가, 상하 마진 추가(mt-5, mb-5) --%>
        <%-- 아이콘 크기, 색상, 하단 여백은 Bootstrap 유틸리티 또는 인라인 style로 약간 조정 가능 --%>
        <i class="fas fa-check-circle mb-3" style="font-size: 4rem; color: var(--success-color);"></i>
        <h2 class="mb-3">회원가입 완료!</h2>
        <p class="lead">북허브의 회원이 되신 것을 진심으로 환영합니다.</p>
        <p>회원가입 절차가 성공적으로 완료되었습니다.<br>이제 로그인하여 북허브의 다양한 서비스를 이용해 보세요.</p>

        <%-- 버튼 그룹 스타일은 Bootstrap 클래스(d-flex, justify-content-center, gap-*)로 처리 --%>
        <div class="d-flex justify-content-center gap-3 mt-4">
            <%-- 홈페이지 링크는 실제 경로로 수정하세요 --%>
            <a href="home.jsp" class="btn btn-outline-secondary">홈페이지로 가기</a>
             <%-- 로그인 페이지 링크는 실제 경로로 수정하세요 --%>
            <a href="signin.jsp" class="btn btn-primary">로그인 페이지로 이동</a>
        </div>
    </div>

    <!-- Footer (회원가입 폼과 동일한 푸터 사용) -->
    <footer class="footer mt-auto py-3 bg-light"> <%-- mt-auto 로 푸터를 아래로 밀거나, 필요시 스타일 조정 --%>
        <div class="container">
            <div class="text-center">
                <small class="text-muted">© 2025 북허브. All rights reserved.</small>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle (Navbar 토글 등 기능에 필요) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>