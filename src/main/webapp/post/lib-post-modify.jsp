<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	String postCateNo = request.getParameter("postCateNo"); // 문의 유형 번호
	int postNo = StringUtils.strToInt(request.getParameter("postNo")); // 게시글 번호 
	String libNoParam = request.getParameter("libNo"); // 게시글의 문의 도서 번호
	String postTitle = request.getParameter("title"); // 게시글 제목.
	String postContent = request.getParameter("content"); // 게시글 내용
	String isPublic = request.getParameter("isPublic");// 공개 및 비공개 처리 여부
	
	PostMapper selectPost = MybatisUtils.getMapper(PostMapper.class);
	Post post = selectPost.getLibPostBypostNo(postNo);
	Library library = new Library();
	
	if(libNoParam != null && !libNoParam.isEmpty()){ 
		int libNo = StringUtils.strToInt(libNoParam);
		library.setNo(libNo);
		post.setLibrary(library);
	}
		
	
	post.setTitle(postTitle);
	post.setContent(postContent);
	post.setIsPublic(isPublic);
	
	selectPost.updatePost(post);
	
	response.sendRedirect("/bookhub/post/post-list-2.jsp?postCateNo=" +postCateNo);
%>     