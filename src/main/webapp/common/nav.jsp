<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">BOOK HUB</a>
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
                        <li><a class="dropdown-item" href="../board.html?type=book">도서 문의</a></li>
                        <li><a class="dropdown-item" href="../board.html?type=library">도서관 문의</a></li>
                        <li><a class="dropdown-item" href="../board.html?type=system">기타/시스템 문의</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="../library.html">북허브소개</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="mypage.jsp">마이페이지</a>
                </li>
                
                <li class="nav-item dropdown">
                    <a class="nav-link" href="#" id="boardDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        카테고리
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="boardDropdown">
                        <li><a class="dropdown-item" href="../board.html?type=book">li태그 반복문 사용하세요</a></li>
                    </ul>
                </li>
            </ul>
            <ul class="navbar-nav">
                <%
                	String loggedInUserId = (String)session.getAttribute("LOGINED_USER_ID");
                	String loggedInUserName = (String)session.getAttribute("LOGINED_USER_NAME");
                	boolean isLoggedIn = (loggedInUserId != null);
                	
                	if (isLoggedIn) {
                		
                %>
                	<li class="nav-item">
                		<span class="nav-link">
                                <%= loggedInUserName %> 님   <!-- 사용자 이름 표시 -->
                        </span>
                	</li>
                    <li class="nav-item">
                        <a class="nav-link" href="mypage.jsp">마이페이지</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">로그아웃</a>
                    </li>
                <%
                	} else {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="signup.jsp">회원가입</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="signin.jsp">로그인</a>
                    </li>
                <%
                	}
                %>
                </ul>
        </div>
    </div>
</nav>