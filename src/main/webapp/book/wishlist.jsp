<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int bookNo = StringUtils.strToInt(request.getParameter("bookNo"));
	String userId = request.getParameter("userId");
	
	// Map 객체 생성
	Map<String, Object> condition = new HashMap<>();
	condition.put("bookNo", bookNo);
	condition.put("userId", userId);
%>

					