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
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation (회원가입 폼과 동일한 네비게이션 사용) -->
    <%@ include file="../common/nav.jsp" %> 

    <div class="signup-container text-center mt-5 mb-5">
        <i class="fas fa-check-circle mb-3" style="font-size: 4rem; color: var(--success-color);"></i>
        <h2 class="mb-3">회원가입 완료!</h2>
        <p class="lead">북허브의 회원이 되신 것을 진심으로 환영합니다.</p>
        <p>회원가입 절차가 성공적으로 완료되었습니다.<br>이제 로그인하여 북허브의 다양한 서비스를 이용해 보세요.</p>

        <div class="d-flex justify-content-center gap-3 mt-4">
            <a href="/bookhub/index.jsp" class="btn btn-outline-secondary">홈페이지로 가기</a>
            <a href="signin.jsp" class="btn btn-primary">로그인 페이지로 이동</a>
        </div>
    </div>

    <!-- Footer (회원가입 폼과 동일한 푸터 사용) -->
	<%@ include file="../common/footer.jsp" %>
    <!-- Bootstrap JS Bundle (Navbar 토글 등 기능에 필요) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>