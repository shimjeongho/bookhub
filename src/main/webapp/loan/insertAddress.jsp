<%@page import="kr.co.bookhub.vo.User"%>
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
	// post 방식으로 넘어온 우편번호, 기본주소, 상세주소
	String zipcode = request.getParameter("zipcode");
	String basicAddress = request.getParameter("basicAddress");
	String addressDetail = request.getParameter("addressDetail");
	String addressName = request.getParameter("addressName");
	String isGibon = request.getParameter("isGibon");
	String id = (String) session.getAttribute("LOGINED_USER_ID");
	AddressMapper addressMapper = MybatisUtils.getMapper(AddressMapper.class);
	
	List<Address> userAddresses = addressMapper.getAllAddressByUserId(id);
	
	isGibon = (isGibon != null && isGibon.equals("on")) ? "Y" : "N";  
	
	// 체크가 안되어있으면 null 값이 오기 때문에 null일 경우 "N" 으로 설정해준다.
	if (userAddresses.isEmpty()) {
    	isGibon = "Y";
	} else {
		if ("Y".equals(isGibon)) {
			Address gibonAddress = addressMapper.getGibonAddressByUserId(id);
			gibonAddress.setGibon("N");
			addressMapper.updateAddressByAddress(gibonAddress);
		}
	}
	
 
	
	// address 객체를 생성해서 담는다.
	Address address = new Address();
	address.setZipcode(zipcode);
	address.setBasic(basicAddress);
	address.setDetail(addressDetail);
	address.setName(addressName);
	address.setGibon(isGibon);
	
	// address객체의 user에 담기 위해 user객체를 생성
	User user = new User();
	user.setId(id);
	
	// 아이디를 담은 user를 address에 담는다.
	address.setUser(user);
	
	// address를 주소테이블에 추가한다.
	addressMapper.insertAddress(address);
	
	response.sendRedirect("/bookhub/user/mypage.jsp?tab=address");
%>
