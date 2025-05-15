<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@page import="com.google.gson.Gson"%> 
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	
	Gson gson = new Gson();

    // 요청 파라미터 받아서 콘솔에 찍어보기 (선택적)
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    
    
 	// 2.구현객체를 획득
 	UserMapper usermapper = MybatisUtils.getMapper(UserMapper.class);
 	// 3.아이디로 사용자 정보 조회.
    User savedUser = usermapper.getUserById(id);
 	
 	//응답으로 보낼 데이터를 담을 Map 객체 생성
    Map<String, Object> responseData = new HashMap<>();
 	
 	if (savedUser == null) {
 		responseData.put("success", false);
 		responseData.put("message", "아이디또는 비밀번호가 올바르지 않습니다.");
 	} else {
 		String secretPassword = DigestUtils.sha256Hex(password);
		if (secretPassword.equals(savedUser.getPassword())) {
			responseData.put("success", true);
            responseData.put("message", "로그인에 성공했습니다!");
            
            String redirectUrl = "/bookhub/index.jsp";
            if ("ADMIN".equals(savedUser.getRole())) {
            	redirectUrl = "/bookhub/user/admin-dashboard.jsp";
            }
            responseData.put("redirectUrl", redirectUrl);
            
            
            session.setAttribute("LOGINED_USER_ID", savedUser.getId());
            session.setAttribute("LOGINED_USER_NAME", savedUser.getName());
            session.setAttribute("LOGINED_USER_PHONE", savedUser.getPhone());
            session.setAttribute("LOGINED_USER_ROLE", savedUser.getRole());
		} else {
			responseData.put("success", false);
			responseData.put("message", "아이디또는 비밀번호가 올바르지 않습니다.");
		}
 	}
 	
 	String jsonResponse = gson.toJson(responseData);
    
    out.print(jsonResponse);
%>