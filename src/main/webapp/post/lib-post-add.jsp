<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.vo.PostCategory"%>
<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = (String)session.getAttribute("LOGINED_USER_ID"); 
	int libNo = StringUtils.strToInt(request.getParameter("libNo")); 
	int postCateNo = StringUtils.strToInt(request.getParameter("postCateNo"));
	String title = request.getParameter("title"); 
	String content = request.getParameter("content");
	String isPublic = request.getParameter("isPublic"); 
	
	Post post = new Post();
	
	//3.Post 객체에 set하기
	post.setTitle(title); 
	post.setContent(content); 
	post.setIsPublic(isPublic);
	
	User user = new User(); 
	Library library = new Library(); 
	PostCategory category = new PostCategory();
	
	user.setId(userId);
	library.setNo(libNo);
	category.setNo(postCateNo); 
	
	post.setUser(user);
	post.setLibrary(library);
	post.setPostCategory(category);
	
	//4.mapper 사용가능하게 해서 post 객체 + insert 쿼리문 실행 
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	mapper.insertLibPost(post);
	
	response.sendRedirect("post-list-2.jsp?postCateNo="+postCateNo);
%>