<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.BookWishListMapper"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. 세션에서 로그인된 사용자의 아이디를 조회한다.
	// String userId = (String) session.getAttribute("LOGINED_USER_ID");
	String userId = "tempuser"; 
	
	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	//String userId = request.getParameter("userId");
	
	// Map 객체 생성
	Map<String, Object> condition = new HashMap<>();
	condition.put("bookNo", bookNo);
	condition.put("userId", userId);
	
	// mapper 가져오기
	BookWishListMapper bookWishListMapper = MybatisUtils.getMapper(BookWishListMapper.class);
	
	// 찜 여부 확인 
	int isBookWish = bookWishListMapper.isBookWish(condition);
	
	// 상태 변경
	boolean isWished;
    if (isBookWish > 0) {
    	// db에서 삭제 시도
        int deletedCount = bookWishListMapper.removeWishList(condition);
        if (deletedCount > 0) {
        }
        isWished = false;
    } else {
        // 중복 체크 다시 한 번
        int checkAgain = bookWishListMapper.isBookWish(condition);
        if (checkAgain == 0) {
            bookWishListMapper.addWishList(condition);
            isWished = true;
        } else {
            isWished = true;
        }
    }
	 
    // 응답 데이터 생성
	Map<String, Object> responseMap = new HashMap<>();
	responseMap.put("isWished", isWished);
	
	Gson gson = new Gson();
	String json = gson.toJson(responseMap); 
 
	// 응답 데이터 전송
	out.write(json);
%>

					