<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%-- 댓글에서 수정 버튼을 누르고 등록을 했을 경우, 처리되는 화면이다. 
	- 서버에서 받는 값: postNo - 게시물 번호, pageNo - 페이지 번호, postCateNo - 문의 유형 번호
	               , 사용자 아이디(세션), 댓글 내용. 
 --%>
<% 
	// 서버에서 값을 추출한다. 
	String userid = "123@123"; // 세션으로 바꿀 예정
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