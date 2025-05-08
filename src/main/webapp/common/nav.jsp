<%@page import="kr.co.bookhub.vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.CategoryBooksMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	CategoryBooksMapper categoryMapper = MybatisUtils.getMapper(CategoryBooksMapper.class);
	List<Category> categories = categoryMapper.getMainCategory();
%>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container">
        <a class="navbar-brand" href="../home.html">BOOKHUB</a>

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
                    <a class="nav-link" href="../mypage.html">마이페이지</a>
                </li>
<%
	if (!categories.isEmpty()) {
%>
                <li class="nav-item dropdown">
                    <a class="nav-link" href="#" id="boardDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        카테고리
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="boardDropdown">
<%
		for (Category cate : categories) {
%>
						<li>
                        	<a class="dropdown-item" href="/bookhub/category/category-books.jsp?cateNo=<%=cate.getNo() %>"><%=cate.getName() %></a>
                        </li>
<%
		}
%>
                    </ul>
                </li>
<%
	}
%>
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