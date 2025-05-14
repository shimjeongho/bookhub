<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.vo.LoanHistory"%>
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
	
	String id = (String) session.getAttribute("LOGINED_USER_ID");
	
	
	LoanBookMapper loanBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
	
	if (loanBookMapper.getLoanHistoryByIdAndBno(id, bno) != null) {
%>
	<script>
		alert("이미 대여 중이거나 반납 신청한 도서입니다.");
		location.href = "/bookhub/book/detail.jsp?bno=<%=bno %>";
	</script>
<% 		
		return;
	}
	
	//재고가 있는지 체크
	StockMapper stockMapper = MybatisUtils.getMapper(StockMapper.class);
	
	int bookStock = stockMapper.getBookStockCount(bno, lno);
	
	if (bookStock <= 0) {
%>
		<script>
			alert("해당 도서의 대여 가능 수량이 없습니다.");
			location.href = "/bookhub/book/detail.jsp?bno=<%=bno %>";
		</script>
	
<%
		return;
	} else {
		loanBookMapper.InsertLoanHistoryByBnoAndRnoAndId(id, lno, bno);
		// 재고테이블에서 해당 도서의 수량을 업데이트
		stockMapper.updateStock(bno, lno);
	
%>
	<script>
		alert("대여가 완료되었습니다.");
		location.href = "/bookhub/user/mypage.jsp?tab=rental";
	</script>
<%	
	}
%>
