<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<% 
	// 서버에서 값을 추출한다. 
	String userid = (String)session.getAttribute("LOGINED_USER_ID"); // 세션으로 바꿀 예정
	String pageNo = request.getParameter("pageNo");
	String postCateNo = request.getParameter("postCateNo");
	String replyModifyContent = request.getParameter("replyModifyContent");
	int postNo = StringUtils.strToInt(request.getParameter("postNo")); 
	int postReplyNo = StringUtils.strToInt(request.getParameter("postReplyNo"));
			
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	
	// 댓글 객체를 생성하여, 이 객체에 단일의 댓글을 조회한 값을 할당한다. 
	PostReply postReply = new PostReply();
	postReply = mapper.getPostReply(postReplyNo, postNo);
	
	// 댓글 객체에 서버에서 추출 받은 값을 set 한다.
	postReply.setContent(replyModifyContent);
	
	
	// 댓글을 업데이트 한다.
	mapper.updatePostReply(postReply);
	
	
	response.sendRedirect("book-post-detail.jsp?postCateNo=" + postCateNo + "&pageNo=" + pageNo + "&postNo=" + postNo);
%>