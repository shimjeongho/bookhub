<%@page import="kr.co.bookhub.mapper.BookMapper"%>
<%@page import="kr.co.bookhub.mapper.BookReviewMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.vo.BookReview"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// String userId = (String) session.getAttribute("LOGINED_USER_ID");
	String userId = "tempuser"; 

	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	int star = StringUtils.strToInt(request.getParameter("star"));
	
	BookReview bookReview = new BookReview();
	bookReview.setTitle(title);
	bookReview.setContent(content);
	bookReview.setStar(star);
	
	BookMapper bookMapper = MybatisUtils.getMapper(BookMapper.class);
	Book book = bookMapper.getBookByNo(bookNo);
	
	User user = new User();
	user.setId(userId);
	
	bookReview.setBook(book);
	bookReview.setWriter(user);
	
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
	
	bookReviewMapper.insertBookReview(bookReview);
	
	book.setReviewCount(book.getReviewCount() + 1);
	
	bookMapper.updateBook(book);
	
	response.sendRedirect("detail.jsp?bno=" + bookNo);
	
%>
					