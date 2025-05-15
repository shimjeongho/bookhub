<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page import="java.util.Date"%>
<%@ page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@ page import="kr.co.bookhub.vo.User" %>
<%@ page import="kr.co.bookhub.util.MybatisUtils" %>
<%@ page import="kr.co.bookhub.mapper.UserMapper" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	// 1.요청 파라미터값을 조회
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	String name = request.getParameter("name");
	String phone = request.getParameter("phone");
	Date birth = StringUtils.strToDate(request.getParameter("birth"));
	
	// 2.구현객체를 획득
	UserMapper usermapper = MybatisUtils.getMapper(UserMapper.class);
	
	// 비밀번호를 암호화한다.
	String secretPassword = DigestUtils.sha256Hex(password);
	
	// 3.User 객체를 생성하고 조회한 파라미터 값을 담음
	User user = new User();
	user.setId(id);
	user.setPassword(secretPassword);
	user.setName(name);
	user.setPhone(phone);
	user.setBirth(birth);
	user.setRole("USER");
	//4. UserMapper 객체의 insertUser메소드를 호출하여 데이터베이스에 저장
	usermapper.insertUser(user);
	
	// 8. 회원가입 완료 페이지를 재요청하는 응답을 보낸다.
	response.sendRedirect("register-complete.jsp");
	

%>