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
  String loggedInUserRole = (String)session.getAttribute("LOGINED_USER_ROLE");
%>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-light" style="z-index: 999;">
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
                    <a class="nav-link" href="/bookhub/search/search.jsp">자료검색</a>
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
                    <a class="nav-link" href="/bookhub/book/library.jsp">도서관소개</a>
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

	            <li class="nav-item">
	                <a class="nav-link" href="/bookhub/donation/donation-board.jsp">도서기부</a>
	            </li>
            
            </ul>
            <ul class="navbar-nav">
                <%
                	if (loggedInUserId != null) {
                %>
                <%
                		if ("ADMIN".equals(loggedInUserRole)) {
                %>
                		<li class="nav-item dropdown">
                            <a class="nav-link" href="#" id="adminMenuDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                관리
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="adminMenuDropdown">
                                <li><a class="dropdown-item" href="/bookhub/user/admin-userManagement.jsp">회원 관리</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/bookhub/user/admin-dashboard.jsp">관리자 홈</a></li>
                            </ul>
                        </li>
                <%
                		}	//관리자 확인 제어문 끝
                %>
                	<li class="nav-item">
                		<a class="nav-link" href="/bookhub/user/mypage.jsp">
                                <%= loggedInUserName %> 님  
                        </a>
                	</li>
                    
                    <li class="nav-item">
                        <a class="nav-link" href="/bookhub/user/logout.jsp">로그아웃</a>
                    </li>
                <%
                	} else {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="/bookhub/user/signup.jsp">회원가입</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/bookhub/user/signin.jsp">로그인</a>
                    </li>
                <%
                	}
                %>
            </ul>
        </div>
    </div>
</nav>
