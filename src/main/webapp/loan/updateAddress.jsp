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
	String id = (String) session.getAttribute("LOGINED_USER_ID");
    int addressNo = StringUtils.strToInt(request.getParameter("no"));
    String zipcode = request.getParameter("zipcode");
    String basicAddress = request.getParameter("basicAddress");
    String addressDetail = request.getParameter("addressDetail");
    String addressName = request.getParameter("addressName");
    String isGibon = request.getParameter("isGibon");
    
    isGibon = (isGibon != null && isGibon.equals("on")) ? "Y" : "N";    
    
	AddressMapper addressMapper = MybatisUtils.getMapper(AddressMapper.class);
	
	List<Address> allAddress = addressMapper.getAllAddressByUserId(id);
	
	// 기존 주소 목록 중에서 기본으로 설정된 주소를 담기 위해 gibonAddress 객체 생성
	Address gibonAddress = addressMapper.getGibonAddressByIdAndNo(id, addressNo);
	
	// 기존 주소가 하나일 경우, 혹은 기본으로 설정된 주소가 없으면 기본을 "Y" 로 설정
	if(allAddress.size() == 1 || gibonAddress == null) {
		isGibon = "Y";
	}

	// 수정된 내용을 address 객체에 담는다.
	Address address = new Address();
	address.setNo(addressNo);
	address.setZipcode(zipcode);
	address.setBasic(basicAddress);
	address.setDetail(addressDetail);
	address.setName(addressName);
	address.setGibon(isGibon);
	
	// 수정하려고 하는 주소가 기본으로 설정되어 있고, gibonAddress가 null 값이 아니면
	if ("Y".equals(isGibon) && gibonAddress != null) {
		gibonAddress.setGibon("N");
		addressMapper.updateAddressByAddress(gibonAddress);
	}
	
	addressMapper.updateAddressByAddress(address);
	
	response.sendRedirect("/bookhub/user/mypage.jsp?tab=address");
%>