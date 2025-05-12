<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String redirectURL = "mypage.jsp?tab=delete"; // 기본 리다이렉션 URL (회원탈퇴 탭으로)

    // 1. 로그인 상태 확인
    String loginedUserId = (String) session.getAttribute("LOGINED_USER_ID");
    if (loginedUserId == null) {
        response.sendRedirect("signin.jsp?error=auth"); // 로그인 페이지로
        return;
    }

    // 2. 요청 파라미터 조회
    String inputPassword = request.getParameter("deletePassword");
    String confirmDelete = request.getParameter("confirmDelete");

    // 3. 유효성 검사 및 상태 전달
    if (inputPassword == null || inputPassword.trim().isEmpty()) {
        response.sendRedirect(redirectURL + "&delete_status=empty_password");
        return;
    }
    if (!"agree".equals(confirmDelete)) {
        response.sendRedirect(redirectURL + "&delete_status=not_agreed");
        return;
    }

    // 4. Mapper 준비
    UserMapper userMapper = MybatisUtils.getMapper(UserMapper.class);

    // 5. DB에서 현재 사용자 정보 조회
    User currentUser = userMapper.getUserById(loginedUserId);

    if (currentUser == null) {
        // 이 경우는 로그인 세션은 있지만 DB에 사용자가 없는 특이 케이스
        // 보통은 signin.jsp로 보내는 것이 적절
        response.sendRedirect("signin.jsp?error=user_not_found");
        return;
    }

    if ("Y".equals(currentUser.getIsDeleted())) {
        response.sendRedirect(redirectURL + "&delete_status=already_deleted");
        return;
    }

    // 6. 비밀번호 확인
    String hashedInputPassword = DigestUtils.sha256Hex(inputPassword);
    String dbPasswordHash = currentUser.getPassword();

    boolean passwordMatch = (dbPasswordHash != null && dbPasswordHash.equals(hashedInputPassword));

    if (passwordMatch) {
        // 7. 회원 탈퇴 처리
        int updatedRows = userMapper.deleteUser(loginedUserId);

        if (updatedRows > 0) {
            session.invalidate(); // 세션 무효화
            // 성공 시 로그인 페이지나 메인 페이지로 리다이렉션.
            // 여기서는 예시로 메인 페이지로 보낸다고 가정하고, 성공 메시지를 쿼리스트링에 포함
            response.sendRedirect("home.jsp?delete_status=success"); // 실제 메인 페이지 경로
        } else {
            response.sendRedirect(redirectURL + "&delete_status=db_error");
        }
    } else {
        // 비밀번호 불일치
        response.sendRedirect(redirectURL + "&delete_status=password_mismatch");
    }
%>