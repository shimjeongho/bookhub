<%@page import="kr.co.bookhub.vo.Category"%>
<%@page import="kr.co.bookhub.vo.PostCategory"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.CategoryBooksMapper"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 맵퍼
	CategoryBooksMapper categoryMapper = MybatisUtils.getMapper(CategoryBooksMapper.class);
	
	// 도서 상위 카테고리 가져오기
	List<Category> categories = categoryMapper.getMainCategory();

  PostMapper postMapper1 = MybatisUtils.getMapper(PostMapper.class);
	List<PostCategory> postCategories = postMapper1.selectPostCategoryInfo(); 
  
  //네비게이션바에 이름 표시
  String loggedInUserId = (String)session.getAttribute("LOGINED_USER_ID");
  String loggedInUserName = (String)session.getAttribute("LOGINED_USER_NAME");
%>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container">
        <a class="navbar-brand" href="/bookhub/index.jsp">
        	<img src="/bookhub/resources/images/bookhub-signature-logo.png" alt="로고" >
       	</a>

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
<% for(PostCategory pCategory : postCategories) { %>                        
                        <li><a class="dropdown-item" href="/bookhub/post/post-list-<%= pCategory.getNo() %>.jsp?postCateNo=<%= pCategory.getNo() %>"><%= pCategory.getName() %></a></li> 
<% 	} %>                            
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="../library.html">북허브소개</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="mypage.jsp">마이페이지</a>
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
                <%
                	if (loggedInUserId != null) {
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
