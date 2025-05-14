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
		요청 파라미터
			lno=xx
		요청 URL
			return.jsp?lno=xxx
		
		1. 넘어온 lno 값을 가져온다.
		2. 해당 lno에 해당하는 도서의 loan_status 값을 변경한다.
	*/
	
	String id = (String) session.getAttribute("LOGINED_USER_ID");
	String lno = request.getParameter("lno");
	
	
	AddressMapper addressMapper = MybatisUtils.getMapper(AddressMapper.class);
	List<Address> userAddresses = addressMapper.getAllAddressByUserId(id);
	
	if (userAddresses.isEmpty()) {
%>
		<script>
			alert("주소를 등록하세요.");
			location.href = "/bookhub/user/mypage.jsp?tab=address";
		</script>
<%
		return;
	}
	
	// 해당 도서 lno 값을 이용해 도서의 대여 상태를 'P'로 수정하고 반납일자를 수정한다.
	LoanBookMapper returnBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
	returnBookMapper.updateLoanStatusAndreturnDateByLoanNo(lno);
%>
		<script>
			alert("반납신청이 완료되었습니다.");
			location.href = "/bookhub/user/mypage.jsp?tab=return#return-" + "<%=lno %>";
		</script>	

