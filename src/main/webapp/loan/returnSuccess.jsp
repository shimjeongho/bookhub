<%@page import="kr.co.bookhub.mapper.StockMapper"%>
<%@page import="kr.co.bookhub.mapper.AddressMapper"%>
<%@page import="kr.co.bookhub.vo.Address"%>
<%@page import="jakarta.websocket.SendResult"%>
<%@page import="kr.co.bookhub.vo.LoanHistory"%>
<%@page import="java.util.Date"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.LoanBookMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%
	/*
	/bookhub/loan/returnSuccess.jsp?bno=xx&lno=xx
	*/
	String libno = request.getParameter("libNo"); // 도서관번호
	String bno = request.getParameter("bno");
	String loanNo = request.getParameter("loanNo");
	
	LoanBookMapper loanBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
	
	loanBookMapper.updateReturnBook(loanNo);
	
	StockMapper stockMapper = MybatisUtils.getMapper(StockMapper.class);
	
	stockMapper.updateBookStock(bno, libno);
	
	response.sendRedirect("/bookhub/user/admin-bookManagement.jsp");
%>




