<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.vo.Donation"%>
<%@page import="kr.co.bookhub.mapper.DonationMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 
		요청 정보
		library, title, author, publisher, description
		
		1. 세션 아이디 조회
		2. 요청 파라미터 정보 조회
		3. donation 객체 생성 후 정보 넣기
		4. DB에 insert 하기
		5. 재요청하기
	*/
	// 나중에 세션, 속성에서 가져오는걸로 변경 예정
	String loginedUserId = "zxcv@zxcv";
	
	// 요청 파라미터 정보 조회
	int libraryNo = StringUtils.strToInt(request.getParameter("library"));
	String title = request.getParameter("title");
	String author = request.getParameter("author");
	String publisher = request.getParameter("publisher");
	String description = request.getParameter("description");
	
	// donation 객체 생성 후 정보 넣기
	Donation donation = new Donation();
	
	User user = new User();
	user.setId(loginedUserId);
	
	Library library = new Library();
	library.setNo(libraryNo);
	
	donation.setTitle(title);
	donation.setAuthor(author);
	donation.setPublisher(publisher);
	donation.setDescription(description);
	donation.setUser(user);
	donation.setLibrary(library);
	
	//DonationMapper 구현객체 획득
	DonationMapper donationMapper = MybatisUtils.getMapper(DonationMapper.class);

	// 기부 도서 insert 작업하기
	donationMapper.insertDonationBook(donation);
	
	// 재요청하기
	response.sendRedirect("donation-board.jsp");
%>









