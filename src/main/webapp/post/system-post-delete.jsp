<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	
	PostMapper selectPost2 = MybatisUtils.getMapper(PostMapper.class); 
	
	Post post = selectPost2.getSystemPostByPostNo(postNo);
	
	post.setIsDeleted("Y"); 
	
	selectPost2.updatePost(post);
	
	response.sendRedirect("/bookhub/post/post-list-3.jsp?postCateNo=" + postCateNo);
%>