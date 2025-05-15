<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 1. 관리자 권한 확인
    String adminDashboardRole = (String) session.getAttribute("LOGINED_USER_ROLE");
    if (!"ADMIN".equals(adminDashboardRole)) {
        // 관리자가 아니면 접근 권한 없음 처리 (예: 메인 페이지로 리다이렉트 또는 에러 메시지)
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=auth_admin_required");
        return; // 현재 페이지 처리 중단
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- Google Fonts - Noto Sans KR -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
<title>관리자 대시보드 - 북허브</title>
</head>
<body>
	<%@ include file="../common/nav.jsp" %>
	
	<div class="container mt-5">
        <h1>관리자 대시보드</h1>
        <p>환영합니다, <%= loggedInUserName %>님!</p>
        <hr>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">회원 관리</h5>
                        <p class="card-text">등록된 회원 정보를 관리할 수 있습니다.</p>
                        <a href="admin-userManagement.jsp" class="btn btn-primary">회원 관리 바로가기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">도서 반납 관리</h5>
                        <p class="card-text">사용자가 반납 신청한 도서 목록을 확인하고, 최종 반납 완료 처리를 합니다.</p>
                        <a href="admin-bookManagement.jsp" class="btn btn-primary">반납 관리 바로가기</a>
                    </div>
                </div>
            </div>
            
        </div>
        
        
    </div>
   
   <!-- Bootstrap JS and jquery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>