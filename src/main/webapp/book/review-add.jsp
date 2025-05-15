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
	//1. 세션에서 로그인된 사용자의 아이디를 조회한다.
	String userId = (String) session.getAttribute("LOGINED_USER_ID");

	// 2. 요청 파라미터값을 조회한다.
	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	int star = StringUtils.strToInt(request.getParameter("star"));
	
	// 3. BookReview객체를 생성해서 필요한 정보를 담는다.
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
	
	// 4. BookReviewMapper 객체를 획득한다.
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
	
	// 5. 테이블에 저장시킨다.
	bookReviewMapper.insertBookReview(bookReview);
	
	// 6. 도서정보의 리뷰갯수를 1증가시킨다.
	book.setReviewCount(book.getReviewCount() + 1);

	// 해당 도서의 리뷰 총점 조회
	int totalPoint = bookReviewMapper.getTotalReviewScore(bookNo);
	
	// 리뷰 평균평점
	int reviewCount = book.getReviewCount();
	double avg = ((double) totalPoint / reviewCount);
	double roundedAvg = StringUtils.round(avg);
	
	// 리뷰 평균평점 가져오기		
	book.setReviewAvg(roundedAvg);
	
	// 7. 변경된 도서정보를 테이블에 반영시킨다.
	bookMapper.updateBook(book);
	
	// 세션에 add complete 담기
	session.setAttribute("complete", "add");
	// 8. detail.jsp를 재요청하는 응답보내기
	response.sendRedirect("detail.jsp?bno=" + bookNo);
	
%>
					