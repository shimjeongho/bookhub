<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");
    UserMapper userMapper = null; // 초기화
    User savedUser = null;       // 초기화

    // 1. id 파라미터가 있고, 비어있지 않은 경우에만 다음 로직 실행
    if (id != null && !id.trim().isEmpty()) {
        userMapper = MybatisUtils.getMapper(UserMapper.class);

        // 2. userMapper가 정상적으로 획득된 경우에만 다음 로직 실행
        if (userMapper != null) {
            savedUser = userMapper.getUserById(id.trim()); // id 앞뒤 공백 제거
        }
    }

    // 3. 결과에 따라 응답
    if (savedUser == null) {
        // id가 없거나, userMapper 획득 실패, 또는 실제로 사용자가 없는 모든 경우
        out.write("none"); 
    } else {
        out.write("exists"); 
    }
%>