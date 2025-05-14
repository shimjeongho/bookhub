<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
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
	String userId = (String) session.getAttribute("LOGINED_USER_ID");

	//2. 요청 파라미터값을 조회한다.
	int reviewNo = StringUtils.strToInt(request.getParameter("reviewNo"));
	String action = request.getParameter("action");
	
	// 3. BookReviewMapper 객체를 획득한다.
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
	
	// 4. 좋아요 증가/감소 처리
	if("increase".equals(action)) {
		bookReviewMapper.increaseLike(reviewNo);	
	} else if("decrease".equals(action)) {
		bookReviewMapper.decreaseLike(reviewNo);
	}
	
	int updatedLikes = bookReviewMapper.getLikesCount(reviewNo);
	
	// 응답 데이터 생성	
	Map<String, Object> responseMap = new HashMap<>();
	responseMap.put("updatedLikes", updatedLikes);
	
	Gson gson = new Gson();
	String json = gson.toJson(responseMap); 
 
	// 응답 데이터 전송
	out.write(json);
%> 
					