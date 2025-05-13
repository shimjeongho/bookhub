<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원탈퇴 완료 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome (아이콘 사용을 위해) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS (기존 스타일 재활용 또는 이 페이지 전용 스타일) -->
    <link href="../resources/css/styles.css" rel="stylesheet"> 
    <style>
        /* 이 페이지에만 적용될 간단한 스타일 (선택적) */
        .completion-container {
            max-width: 600px;
            margin-top: 5rem;
            margin-bottom: 5rem;
        }
        .completion-icon {
            font-size: 4rem;
            color: var(--bs-primary); /* Bootstrap primary color */
        }
    </style>
</head>
<body>
    <!-- Navigation (기존 네비게이션 바 include 또는 직접 작성) -->
    <%@ include file="../common/nav.jsp" %> 
    

    <div class="signup-container text-center mt-5 mb-5">
        <i class="fas fa-user-check mb-3 completion-icon"></i> 
        <h2 class="mb-3">회원탈퇴 완료</h2>
        <p class="lead">북허브 이용을 종료하셨습니다.</p>
        <p>회원탈퇴 절차가 성공적으로 완료되었습니다.<br>그동안 북허브를 이용해주셔서 감사합니다.</p>
        <p>다음에 더 좋은 서비스로 만날 수 있기를 바랍니다.</p>

        <div class="d-flex justify-content-center gap-3 mt-4">
            <a href="/bookhub/index.jsp" class="btn btn-primary">홈페이지로 가기</a>
            <a href="signup.jsp" class="btn btn-outline-secondary">회원가입 페이지로 가기</a>
        </div>
    </div>

    <!-- Footer (기존 푸터 include 또는 직접 작성) -->
    <%@ include file="../common/footer.jsp" %> 

    <!-- Bootstrap JS Bundle (Navbar 토글 등 기능에 필요) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>