<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//json객체와 맵 생성
	Map<String, Object> responseData = new HashMap<>();
	Gson gson = new Gson();

	// 1. 세션에서 로그인된 사용자 ID 가져오기
	String loginedUserId = (String) session.getAttribute("LOGINED_USER_ID");

	if (loginedUserId == null) {
        responseData.put("success", false);
        responseData.put("message", "로그인이 필요한 서비스입니다.");
        responseData.put("errorField", "auth"); // 클라이언트 JS에서 auth 필드 처리
        out.print(gson.toJson(responseData));
        out.flush();
        return; // 처리 중단
    }

	// 2. 요청 파라미터 받기 (클라이언트 dataToSend의 key와 일치)
	// 클라이언트에서 fullName, phone, password, newPassword, confirmPassword 로 보냄
	String name = request.getParameter("fullName"); // 클라이언트에서 fullName으로 보냈으므로 fullName으로 받음
	String phone = request.getParameter("phone");
	String currentPassword = request.getParameter("password"); // 사용자가 입력한 현재 비밀번호
	String newPassword = request.getParameter("newPassword");
	String confirmPassword = request.getParameter("confirmPassword");

	// 유효성 검사 정규식
	String phoneRegex = "^[0-9]{3}-[0-9]{3,4}-[0-9]{4}$";
    String passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";

    // 비밀번호 변경 시도 여부 (셋 중 하나라도 값이 있으면 변경 시도)
    // trim() 결과가 비어있지 않은지로 확인
    boolean isPasswordChangeAttempt = (currentPassword != null && !currentPassword.trim().isEmpty()) ||
                                      (newPassword != null && !newPassword.trim().isEmpty()) ||
                                      (confirmPassword != null && !confirmPassword.trim().isEmpty());


    // 3. 서버 측 유효성 검사
    // 이름 (필수)
    if (name == null || name.trim().isEmpty()) {
        responseData.put("success", false);
        responseData.put("message", "이름을 입력해주세요.");
        responseData.put("errorField", "fullName"); // 클라이언트 필드 ID와 일치하도록 "fullName"으로 수정
        out.print(gson.toJson(responseData));
        return;
    }

    // 휴대전화번호 (필수, 형식 검사)
    if (phone == null || phone.trim().isEmpty()) {
        responseData.put("success", false);
        responseData.put("message", "휴대폰 번호를 입력해주세요.");
        responseData.put("errorField", "phone"); // 클라이언트 필드 ID와 일치
        out.print(gson.toJson(responseData));
        return;
    }
    if (!phone.matches(phoneRegex)) {
        responseData.put("success", false);
        responseData.put("message", "올바른 휴대폰 번호 형식이 아닙니다. (예: 010-1234-5678)");
        responseData.put("errorField", "phone"); // 클라이언트 필드 ID와 일치
        out.print(gson.toJson(responseData));
        return;
    }

    // 비밀번호 변경 시도 시 관련 필드 검사
    if (isPasswordChangeAttempt) {
        // 현재 비밀번호 (필수, 형식 검사)
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            responseData.put("success", false);
            responseData.put("message", "현재 비밀번호를 입력해주세요.");
            responseData.put("errorField", "password"); // 클라이언트의 currentPassword 필드 ID와 일치
            out.print(gson.toJson(responseData));
            return;
        }
        // 비밀번호 형식 검사
        if (!currentPassword.matches(passwordRegex)) {
             responseData.put("success", false);
             responseData.put("message", "현재 비밀번호 형식이 올바르지 않습니다. (영문,숫자,특수문자 포함 8자 이상)");
             responseData.put("errorField", "password"); // 클라이언트 필드 ID와 일치
             out.print(gson.toJson(responseData));
             return;
        }

        // 새 비밀번호 (필수, 형식 검사) - **올바른 블록으로 이동**
        if (newPassword == null || newPassword.trim().isEmpty()) {
            responseData.put("success", false);
            responseData.put("message", "새 비밀번호를 입력해주세요.");
            responseData.put("errorField", "newPassword"); // 클라이언트 필드 ID와 일치
            out.print(gson.toJson(responseData));
            return;
        }
        // 비밀번호 형식 검사
        if (!newPassword.matches(passwordRegex)) {
            responseData.put("success", false);
            responseData.put("message", "새 비밀번호 형식이 올바르지 않습니다. (영문,숫자,특수문자 포함 8자 이상)");
            responseData.put("errorField", "newPassword"); // 클라이언트 필드 ID와 일치
            out.print(gson.toJson(responseData));
            return;
        }

        // 새 비밀번호 확인 (필수, 형식 검사) - **올바른 블록으로 이동**
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            responseData.put("success", false);
            responseData.put("message", "새 비밀번호 확인을 입력해주세요.");
            responseData.put("errorField", "confirmPassword"); // 클라이언트 필드 ID와 일치
            out.print(gson.toJson(responseData));
            return;
        }
        // 비밀번호 형식 검사 (새 비밀번호와 동일한 규칙 적용)
        if (!confirmPassword.matches(passwordRegex)) {
            responseData.put("success", false);
            responseData.put("message", "새 비밀번호 확인 형식이 올바르지 않습니다. (영문,숫자,특수문자 포함 8자 이상)");
            responseData.put("errorField", "confirmPassword"); // 클라이언트 필드 ID와 일치
            out.print(gson.toJson(responseData));
            return;
        }

        // 새 비밀번호와 새 비밀번호 확인 일치 여부 - **올바른 블록으로 이동**
        if (!newPassword.equals(confirmPassword)) {
            responseData.put("success", false);
            responseData.put("message", "새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.");
            responseData.put("errorField", "confirmPassword"); // 에러는 확인 필드에 표시
            out.print(gson.toJson(responseData));
            return;
        }

    } 

    // 4. DB 처리
    UserMapper userMapper = MybatisUtils.getMapper(UserMapper.class);
    User savedUser = userMapper.getUserById(loginedUserId);

    if (savedUser == null) {
        responseData.put("success", false);
        responseData.put("message", "사용자 정보를 찾을 수 없습니다.");
        out.print(gson.toJson(responseData));
        return;
    }

    // 비밀번호 변경 시도 시, 실제 DB의 현재 비밀번호와 입력된 현재 비밀번호 일치 검증 (유효성 검사 통과 후)
    if (isPasswordChangeAttempt) {
        String hashedCurrentPasswordFromUser = DigestUtils.sha256Hex(currentPassword);
        if (!savedUser.getPassword().equals(hashedCurrentPasswordFromUser)) {
            responseData.put("success", false);
            responseData.put("message", "현재 비밀번호가 일치하지 않습니다.");
            responseData.put("errorField", "password"); // 클라이언트의 currentPassword 필드 ID와 일치
            out.print(gson.toJson(responseData));
            return;
        }
        // 모든 비밀번호 변경 조건 통과, 새 비밀번호로 업데이트 (해시해서)
        savedUser.setPassword(DigestUtils.sha256Hex(newPassword));
    }

    // 이름, 전화번호 업데이트
    savedUser.setName(name.trim()); 
    savedUser.setPhone(phone.trim()); 

    userMapper.updateUser(savedUser); 

    // 5. 세션 정보 업데이트 (선택적이지만, 사용자 경험을 위해 권장)
    session.setAttribute("LOGINED_USER_NAME", savedUser.getName());
    session.setAttribute("LOGINED_USER_PHONE", savedUser.getPhone());

    // 6. 성공 응답
    responseData.put("success", true);
    String successMessage = "회원 정보가 성공적으로 수정되었습니다.";
    if (isPasswordChangeAttempt) {
         successMessage = "회원 정보 및 비밀번호가 성공적으로 수정되었습니다.";
    }
    responseData.put("message", successMessage);

    out.print(gson.toJson(responseData));

%>