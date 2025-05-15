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
	
	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	int isBookWish = StringUtils.strToInt(request.getParameter("isBookWish"));
	
	// Map 객체 생성
	Map<String, Object> condition = new HashMap<>();
	condition.put("bookNo", bookNo);
	condition.put("userId", userId);
	condition.put("isBookWish", isBookWish);
	
	// mapper 가져오기	
	BookWishListMapper bookWishListMapper = MybatisUtils.getMapper(BookWishListMapper.class);
	
	// 처리 여부
	String updated;
	
	if (isBookWish > 0) {
		bookWishListMapper.removeWishList(condition);
		updated = "0";
	} else {
		bookWishListMapper.addWishList(condition);
		updated = "1";
	}
	
	out.write(updated);
%>

					