<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.BookWishListMapper"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    trimDirectiveWhitespaces="true"%>
<%
	//1. 세션에서 로그인된 사용자의 아이디를 조회한다.
	String userId = (String) session.getAttribute("LOGINED_USER_ID");
	
	//2. 요청 파라미터값을 조회한다.
	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	int isBookWish = StringUtils.strToInt(request.getParameter("isBookWish"));
	
	// Map 객체 생성
	Map<String, Object> condition = new HashMap<>();
	condition.put("bookNo", bookNo);
	condition.put("userId", userId);
	condition.put("isBookWish", isBookWish);
	
	// BookWishListMapper 객체 획득	
	BookWishListMapper bookWishListMapper = MybatisUtils.getMapper(BookWishListMapper.class);
	
	// 처리 여부
	String updated;
	
	// 삭제 : 0, 추가 : 1
	if (isBookWish > 0) {
		bookWishListMapper.removeWishList(condition);
		updated = "0";
	} else {
		bookWishListMapper.addWishList(condition);
		updated = "1";
	}
	
	// out은 jsp의 내장객체(JspWriter 객체)가 저장되어 있는 변수다.
	// JspWriter의 writer(데이터) 메소드를 실행하면 데이터가 브라우저로 보내진다.
	out.write(updated);
%>

					