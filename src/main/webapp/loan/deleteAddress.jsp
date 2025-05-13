<%@page import="kr.co.bookhub.vo.Address"%>
<%@page import="kr.co.bookhub.mapper.AddressMapper"%>
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
	String id = "hong@gmail.com";
	String no = request.getParameter("no");
	
	AddressMapper addressMapper = MybatisUtils.getMapper(AddressMapper.class);
	addressMapper.deleteAddressByNo(no);
%>	
<script>
	alert("주소가 삭제되었습니다.");
	location.href = "/bookhub/loan/mypage.jsp?tab=address";
</script>
