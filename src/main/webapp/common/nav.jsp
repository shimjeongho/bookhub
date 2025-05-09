<%@page import="kr.co.bookhub.vo.PostCategory"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<% 
	PostMapper postMapper = MybatisUtils.getMapper(PostMapper.class);
	List<PostCategory> categories = postMapper.selectPostCategoryInfo(); 
%>    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOOKHUB</title>
    <!-- Google Fonts - Noto Sans KR -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../common/nav.jsp" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="/bookhub/post/home.jsp">BOOKHUB</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="../search.html">자료검색</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link" href="#" id="boardDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            게시판
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="boardDropdown">
<% for(PostCategory category : categories) { %>                        
                            <li><a class="dropdown-item" href="/bookhub/post/post-list-<%= category.getNo() %>.jsp?postCateNo=<%= category.getNo() %>"><%= category.getName() %></a></li> 
<% 	} %>                            
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../library.html">도서관소개</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../mypage.html">마이페이지</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="../login.html">로그인</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="../signup.html">회원가입</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>