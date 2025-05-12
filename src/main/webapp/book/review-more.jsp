<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.vo.BookReview"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.BookReviewMapper"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	int pageNo = StringUtils.strToInt(request.getParameter("page"));
	int totalRows = StringUtils.strToInt(request.getParameter("totalRows"));
	String sort = request.getParameter("sort");
	
	// Map 객체 생성
	Map<String, Object> condition = new HashMap<>();
	condition.put("bookNo", bookNo);
	condition.put("page", pageNo);
	condition.put("totalRows", totalRows);
	condition.put("sort", sort);
	
	// 페이지네이션 객체를 생성
	Pagination pagination = new Pagination(pageNo, totalRows);
	// 필터링 조건에 offset과 rows를 추가
	condition.put("offset", pagination.getOffset());
	condition.put("rows", pagination.getRows());
	
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
	
	List<BookReview> bookReviews = bookReviewMapper.getBookReviewsByBookNo(condition);
	
	Gson gson = new GsonBuilder()
			.setDateFormat("yyyy년 M월 d일 a h시 m분 s초")
			.create();
	String json = gson.toJson(bookReviews);
	
	// out은 jsp의 내장객체(JspWriter 객체)가 저장되어 있는 변수다.
	// JspWriter의 writer(데이터) 메소드를 실행하면 데이터가 브라우저로 보내진다.
	out.write(json);
%>
					