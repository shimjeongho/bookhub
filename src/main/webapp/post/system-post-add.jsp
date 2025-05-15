<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.vo.PostCategory"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	//서버에서 받은 값 추출
	String userId = (String)session.getAttribute("LOGINED_USER_ID"); 
	int postCateNo = StringUtils.strToInt(request.getParameter("postCateNo"));
	String title = request.getParameter("title"); 
	String content = request.getParameter("content");
	String isPublic = request.getParameter("isPublic"); 
	
	//Post 객체 생성 
	Post post = new Post();
	
	//3.Post 객체에 set하기
	post.setTitle(title); 
	post.setContent(content); 
	post.setIsPublic(isPublic);
	
	//3-1.사용자 아이디, 게시판 유형 번호, 문의 도서 번호를 넣기 위해 
	// User, Book, PostCategory 객체들을 생성하고 각 객체에 set 한 다음 
	// Post 객체에 할당. 
	User user = new User(); 
	PostCategory category = new PostCategory();
	
	user.setId(userId);
	category.setNo(postCateNo); 
	
	post.setUser(user);
	post.setPostCategory(category);
	
	//4.mapper 사용가능하게 해서 post 객체 + insert 쿼리문 실행 
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	mapper.insertSystemPost(post);
	
	//도서 문의 게시판의 초기화면으로 이동한다. + 공개여부에 대한 값도 들고 간다.
	response.sendRedirect("post-list-3.jsp?postCateNo="+postCateNo);
%>