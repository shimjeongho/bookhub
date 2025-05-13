<%@page import="jakarta.websocket.SendResult"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		요청정보
			- 요청 URL
				/bookstore/logout.jsp
			- 요청파라미터
				없음
		
		요청처리 절차
			1. 세션객체를 무효화시킨다.
			2. index.jsp를 재요청하는 응답을 보낸다.
	*/
	
	// 1. 세션객체를 무효화시킨다.
	session.invalidate();
	
	// 2. index.jsp를 재요청하는 응답을 보낸다.
	response.sendRedirect("/bookhub/index.jsp");
%>

					