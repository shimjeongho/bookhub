<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
 <%-- 댓글에서 삭제 버튼을 누르면 해당 페이지로 넘어온다. 
 	- 서버에서 받는 값 :postCateNo , postNo, pageNo, postReplyNo
 	- 댓글을 지워도 대댓글은 표시하게 한다.
 	
 --%>
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo")); 
	String pageNo = request.getParameter("pageNo");
	int postReplyNo = StringUtils.strToInt(request.getParameter("postReplyNo"));
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	
	// 특정 게시글의 특정 댓글을 지운다.
	PostReply postReply = mapper.getPostReply(postReplyNo, postNo);
	
	// 댓글을 지운다. 
	postReply.setIsDeleted("Y"); 
	
	mapper.updatePostReply(postReply);
	
	response.sendRedirect("book-post-detail.jsp?postCateNo=" + postCateNo + "&pageNo=" + pageNo + "&postNo=" + postNo);
%>