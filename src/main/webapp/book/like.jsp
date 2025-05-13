<%@page import="kr.co.bookhub.mapper.BookReviewMapper"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.vo.BookReview"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.mapper.BookMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. 세션에서 로그인된 사용자의 아이디를 조회한다.
	String userId = "tempuser";

	//2. 요청 파라미터값을 조회한다.
	int bookNo = StringUtils.strToInt(request.getParameter("bno"));
	int reviewNo = StringUtils.strToInt(request.getParameter("rno"));
	int likes = StringUtils.strToInt(request.getParameter("like"));
	
	// 3. BookReview객체를 생성해서 필요한 정보를 담는다.
	BookReview bookReview = new BookReview();
	bookReview.setLikes(likes);
	
	BookMapper bookMapper = MybatisUtils.getMapper(BookMapper.class);
	Book book = bookMapper.getBookByNo(bookNo);
	
	User user = new User();
	user.setId(userId);
	
	bookReview.setBook(book);
	bookReview.setWriter(user);
	
	// 4. BookReviewMapper 객체를 획득한다.
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
%> 
					