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
		요청 파라미터
			lno=xx
		요청 URL
			extension.jsp?lno=xxx
		
		1. 넘어온 lno 값을 가져온다.
		2. 해당 lno의 연장여부를 확인한다.
			if
				연장여부가 'Y'이면 연장을 허용하지 않는다.
				mypage.jsp 페이지로 alert('이미 연장한 도서입니다.') 알림을 실행하도록한다.
				
			else
				반납일을 2주 연장하도록 하고 연장여부를 'Y'로 업데이트한다.
				mypage.jsp 페이지로 alert('연장을 완료했습니다.') 알림을 실행하도록한다.
	*/
	
	String id = "hong@gmail.com";
	String lno = request.getParameter("lno");
	
	LoanBookMapper loanbookmapper = MybatisUtils.getMapper(LoanBookMapper.class);
	
	// 대여번호를 통해 도서의 반납일을 연장하고, 연장여부를 'Y'로 업데이트 한다.
	loanbookmapper.updateIsExtensionAndDueDateByLoanNo(lno);
%>
	<script>
		alert("연장이 완료되었습니다.")
		location.href = "/bookhub/loan/mypage.jsp?tab=rental#loan-"+ "<%=lno %>";
	</script>
