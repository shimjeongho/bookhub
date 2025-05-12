<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- 사용자 본인의 게시글 상세페이지로 들어왔을 때 삭제버튼을 누른다면 해당 페이지로 와서 
     삭제 작업이 이루어지는 페이지. --%>    
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	
	PostMapper selectPost2 = MybatisUtils.getMapper(PostMapper.class); 
	
	Post post = selectPost2.selectPostBypostNo(postNo);
	
	post.setIsDeleted("Y"); 
	
	selectPost2.updatePost(post);
	
	response.sendRedirect("/bookhub/post/post-list-1.jsp?postCateNo=" + postCateNo);
	

%>