<%@page import="kr.co.bookhub.mapper.LoanBookMapper"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.vo.LoanHistory"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // UTF-8 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    // 기본 리다이렉션 URL (회원탈퇴 탭으로)
    String redirectURL = "mypage.jsp?tab=delete";

    // 1. 로그인 상태 확인
    String loginedUserId = (String) session.getAttribute("LOGINED_USER_ID");
    
    // 대여, 혹은 반납신청한 책이 있을 경우에는 회원탈퇴를 하지 못하도록 함
    LoanBookMapper loanBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
    List<LoanHistory> loanBooks = loanBookMapper.getAllBookByUserId(loginedUserId);
    if (!loanBooks.isEmpty()) {
%>
	<script>
		alert("대여, 혹은 반납처리 중인 책이 있습니다.");
		location.href = "mypage.jsp?tab=rental";
	</script>
<%
		return;
    }
    
    if (loginedUserId == null) {
        response.sendRedirect("signin.jsp?error=auth"); // 로그인 페이지로
        return;
    }

    // 2. 요청 파라미터 조회
    String inputPassword = request.getParameter("deletePassword"); // 클라이언트 폼의 name 속성과 일치해야 함
    String confirmDelete = request.getParameter("confirmDelete");   // 클라이언트 폼의 name 속성과 일치, value="agree"

    // 3. 유효성 검사
    // 비밀번호 입력 여부
    if (inputPassword == null || inputPassword.trim().isEmpty()) {
        response.sendRedirect(redirectURL + "&delete_status=empty_password");
        return;
    }
    // 탈퇴 동의 여부 (클라이언트에서 value="agree"로 전송되어야 함)
    if (!"agree".equals(confirmDelete)) {
        response.sendRedirect(redirectURL + "&delete_status=not_agreed");
        return;
    }

    // 4. Mapper 준비
    UserMapper userMapper = MybatisUtils.getMapper(UserMapper.class);

    // 5. DB에서 현재 사용자 정보 조회
    User currentUser = userMapper.getUserById(loginedUserId);

    // 사용자 정보가 없는 경우 (DB에 사용자가 없거나 삭제된 경우 등)
    if (currentUser == null) {
        // 이 경우는 로그인 세션은 있지만 DB에 사용자가 없는 특이 케이스
        response.sendRedirect("signin.jsp?error=user_not_found");
        return;
    }

    // 이미 탈퇴 처리된 사용자인지 확인
    if ("Y".equals(currentUser.getIsDeleted())) {
        response.sendRedirect(redirectURL + "&delete_status=already_deleted");
        return;
    }

    // 6. 비밀번호 일치 확인
    String hashedInputPassword = DigestUtils.sha256Hex(inputPassword);
    String dbPasswordHash = currentUser.getPassword();

    boolean passwordMatch = (dbPasswordHash != null && dbPasswordHash.equals(hashedInputPassword));

    if (passwordMatch) {
        // 비밀번호 일치: 회원 탈퇴 처리 (DB 업데이트)
        userMapper.deleteUser(loginedUserId); // 반환 타입 void, 자동 커밋 가정

        // 세션 무효화
        session.invalidate();

        // 성공 시 메인 페이지 또는 로그인 페이지로 리다이렉션
        response.sendRedirect("delete-success.jsp"); // 성공 메시지 포함
        return; // 리다이렉션 후에는 더 이상 코드 실행 필요 없음

    } else {
        // 비밀번호 불일치
%>
		<script>
			alert("비밀번호가 일치하지 않습니다.");
			location.href = "mypage.jsp?tab=fail";
		</script>
<%        
    }
%>