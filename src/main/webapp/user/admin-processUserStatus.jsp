<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String redirectPage = "admin-userManagement.jsp";
    String targetUserId = request.getParameter("id");
    String action = request.getParameter("action"); // 'delete' 또는 'restore'
    String loggedInAdminId = (String) session.getAttribute("LOGINED_USER_ID");
    String adminRole = (String) session.getAttribute("LOGINED_USER_ROLE");

    String processStatus = "error"; // 기본 상태는 에러
    String processMsg = "";

    // 1. 관리자 권한 확인
    if (!"ADMIN".equals(adminRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=auth_admin_required");
        return;
    }

    // 2. 필수 파라미터 유효성 검사
    if (targetUserId == null || targetUserId.trim().isEmpty() || action == null || action.trim().isEmpty()) {
        processMsg = "noParameter";
        response.sendRedirect(redirectPage + "?process_status=" + processStatus + "&msg=" + processMsg);
        return;
    }

    // 3. 자기 자신 처리 시도 방지 (탈퇴의 경우만)
    if ("delete".equals(action) && targetUserId.equals(loggedInAdminId)) {
        processMsg = "blockedSelfDelete";
        response.sendRedirect(redirectPage + "?process_status=" + processStatus + "&msg=" + processMsg);
        return;
    }

    UserMapper userMapper = MybatisUtils.getMapper(UserMapper.class);
    User targetUser = userMapper.getUserByIdForAdmin(targetUserId); // is_deleted 상태와 관계없이 조회

    if (targetUser == null) {
        processMsg = "ERR_USER_NOT_FOUND"; // 예: 영어 오류 코드
    } else {
        if ("delete".equals(action)) {
            if ("ADMIN".equals(targetUser.getRole())) { // 다른 관리자 탈퇴 시도
                processMsg = "ERR_CANNOT_DELETE_ADMIN";
            } else { // 정상적인 탈퇴 처리
                userMapper.deleteUser(targetUserId);
                processStatus = "delete_success";
            }
        } else if ("restore".equals(action)) {
              userMapper.restoreUser(targetUserId);
              processStatus = "restore_success";
        }
        
    }
    
    // 6. 처리 결과에 따라 사용자 목록 페이지로 리다이렉트
    String redirectUrl = redirectPage + "?process_status=" + processStatus;
    if (processMsg != null && !processMsg.isEmpty()) {
        redirectUrl += "&msg=" + processMsg; 
    }
    response.sendRedirect(redirectUrl);
%>