<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- 게시글 상세 페이지 -> 댓글 등록 버튼을 누르면 넘어오는 화면.
	- postCateNo, pageNo, postNo, replyContent, 사용자 아이디(세션) 값이 넘어온다.
--%>

<%
	String userId = "123@123"; // 세션으로 바꿀 예정
	String pageNo = request.getParameter("pageNo");
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	String replyContent = request.getParameter("replyContent");
	
	PostReply postReply = new PostReply();
	User user = new User();
	Post post = new Post();
	
	user.setId(userId);
	postReply.setUser(user);
	
	post.setNo(postNo);
	postReply.setPost(post);
	
	postReply.setContent(replyContent);
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	mapper.insertPostReply(postReply);
	
	response.sendRedirect("book-post-detail.jsp?postCateNo=" + postCateNo + "&pageNo=" + pageNo + "&postNo=" + postNo);
%>
