<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- book-post-modify-form에서 수정 버튼을 누르면, 수정 처리를 페이지. 
     - pageNo를 전달받아, 먼저 해당 게시글을 조회. 
     - 조회된 게시글을 Post 객체에 할당. 
     - 그 Post 객체에 bookNo, postTitle, postContent,isPublic 값을 set한다.
     - update하는 쿼리문을 호출하여 해당 Post 객체를 인자값으로 전달한다. --%> 
     
<% 
	String postCateNo = request.getParameter("postCateNo"); // 문의 유형 번호
	int postNo = StringUtils.strToInt(request.getParameter("postNo")); // 게시글 번호 
	String bookNoParam = request.getParameter("bookNo"); // 게시글의 문의 도서 번호
	String postTitle = request.getParameter("postTitle"); // 게시글 제목.
	String postContent = request.getParameter("postContent"); // 게시글 내용
	String isPublic = request.getParameter("isPublic");// 공개 및 비공개 처리 여부
	
	PostMapper selectPost = MybatisUtils.getMapper(PostMapper.class);
	Post post = selectPost.selectPostBypostNo(postNo); 
	Book book = new Book();
	
	if(bookNoParam != null && !bookNoParam.isEmpty()){ 
		int bookNo = StringUtils.strToInt(bookNoParam);
		book.setNo(bookNo);
		post.setBook(book);
	}
		
	
	post.setTitle(postTitle);
	post.setContent(postContent);
	post.setIsPublic(isPublic);
	
	selectPost.updatePost(post);
	
	response.sendRedirect("/bookhub/post/post-list-1.jsp?postCateNo=" +postCateNo);
	
	

%>     
