<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="kr.co.bookhub.mapper.StockMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.LoanBookMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%
	/*
		요청 url
			../loan/loan.jsp?bno=xx&lno=xx
		
		1. 책번호(bno)와 도서관 번호(lno)를 쿼리스트링으로 받는다.
		2. 해당 유저 아이디를 세션으로 받는다.
		3. 도서 대여 이력에 insert문을 실행한다.
	
	*/
	String bno = request.getParameter("bno");
	String lno = request.getParameter("lno");
	
	String id = "hong@gmail.com";
	
	LoanBookMapper loanBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
	loanBookMapper.InsertLoanHistoryByBnoAndRnoAndId(id, lno, bno);
	// 재고테이블에서 해당 도서의 수량을 업데이트
	StockMapper stockMapper = MybatisUtils.getMapper(StockMapper.class);
	stockMapper.updateStock(bno, lno);
	
	// 책번호, 도서관번호, 아이디를 통해 대여이력테이블에 대여이력을 추가한다.
	
	response.sendRedirect("mypage.jsp?tab=rental");
%>
