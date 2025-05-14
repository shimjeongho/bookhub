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
	- 단, 답글을 등록하는 경우, postReplyNo값도 같이 넘어온다.
	- 따라서 postReplyNo가 있는 경우, 또는 postReplyNo가 없는 경우로 나눠서 등록한다.
	- postReplyNo가 없는 경우는 그냥 댓글을 다는 경우, postReplyNo가 있는 경우 답글을 다는 경우이다.
--%>

<%	
	// 서버에서 요청 받은 값을 가져온다.
	String userId = "123@123"; // 세션으로 바꿀 예정
	String pageNo = request.getParameter("pageNo");
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	String replyContent = request.getParameter("replyContent");
	String postReplyNoParam = request.getParameter("postReplyNo");	
	String replyReplyContent = request.getParameter("replyReplyContent");
	 
	// 댓글 객체에 서버에서 요청 받은 값들을 할당한다.
	PostReply postReply = new PostReply();
	User user = new User();
	Post post = new Post();
	
	user.setId(userId);
	postReply.setUser(user);
	
	post.setNo(postNo);
	postReply.setPost(post);
	
	postReply.setContent(replyContent);
	
	if(postReplyNoParam != null) {
		int postReplyNo = StringUtils.strToInt(postReplyNoParam);
		PostReply postReply2 = new PostReply(); 
		postReply2.setNo(postReplyNo);
		postReply.setPostReply(postReply2);
		postReply.setContent(replyReplyContent);
	}
	
	//댓글 등록을 실시한다. 
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	mapper.insertPostReply(postReply);
	
	//돌아간다.
	response.sendRedirect("book-post-detail.jsp?postCateNo=" + postCateNo + "&pageNo=" + pageNo + "&postNo=" + postNo);
%>
