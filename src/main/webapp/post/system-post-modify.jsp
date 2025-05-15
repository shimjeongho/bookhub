<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	String postTitle = request.getParameter("title");
	String postContent = request.getParameter("content");
	String isPublic = request.getParameter("isPublic");
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	
	Post post = mapper.getSystemPostByPostNo(postNo);
	
	post.setTitle(postTitle);
	post.setContent(postContent);
	post.setIsPublic(isPublic);
	
	mapper.updatePost(post);
	
	response.sendRedirect("/bookhub/post/post-list-3.jsp?postCateNo=" +postCateNo);
%>