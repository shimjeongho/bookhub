<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.mapper.UserMapper"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 1. 관리자 권한 확인
    String adminUserMgmtRole = (String) session.getAttribute("LOGINED_USER_ROLE");
    if (!"ADMIN".equals(adminUserMgmtRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=auth_admin_required");
        return;
    }

    // 2. 사용자 목록 조회
    UserMapper userMapper = MybatisUtils.getMapper(UserMapper.class);
    List<User> users = userMapper.getAllUsers();

    // 처리 결과 메시지
    String processStatus = request.getParameter("process_status");
    String processMsg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>회원 관리 - 북허브</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <%@ include file="../common/nav.jsp" %>

    <div class="container mt-5">
        <h1>회원 관리</h1>
        <hr>

        <%-- 처리 결과 메시지 표시 --%>
        <% if ("delete_success".equals(processStatus)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                사용자 계정이 성공적으로 탈퇴 처리되었습니다.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("restore_success".equals(processStatus)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                사용자 계정이 성공적으로 복구되었습니다.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("error".equals(processStatus) && processMsg != null && !processMsg.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>오류:</strong> <%= processMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <table class="table table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th scope="col">아이디</th>
                    <th scope="col">이름</th>
                    <th scope="col">연락처</th>
                    <th scope="col">역할</th>
                    <th scope="col">가입일</th>
                    <th scope="col">상태</th>
                    <th scope="col" class="text-center">관리</th>
                </tr>
            </thead>
            <tbody>
<%
    if (users == null || users.isEmpty()) {
%>
                <tr>
                    <td colspan="7" class="text-center py-5">
                        <p class="mb-0 text-muted">등록된 사용자가 없습니다.</p>
                    </td>
                </tr>
<%
    } else {
        for (User user : users) {
%>
                <tr>
                    <td><%= user.getId()%></td>
                    <td><%= user.getName()%></td>
                    <td><%= user.getPhone()%></td>
                    <td>
<%
            if ("ADMIN".equals(user.getRole())) {
%>
                        <span class="badge text-bg-danger">관리자</span>
<%
            } else {
%>
                        <span class="badge text-bg-primary">일반회원</span>
<%
            }
%>
                    </td>
                    <td><%= StringUtils.simpleDate(user.getCreatedDate()) %></td>
                    <td>
<%
            if ("Y".equals(user.getIsDeleted())) {
%>
                        <span class="badge text-bg-secondary">탈퇴</span>
<%
            } else {
%>
                        <span class="badge text-bg-success">활성</span>
<%
            }
%>
                    </td>
                    <td class="text-center">
<%
            if (!"Y".equals(user.getIsDeleted())) { // 활성 사용자
                if (!user.getRole().equals("ADMIN")) {
%>
                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmUserAction('delete', '<%= user.getId() %>', '<%= user.getName() %>')">
                            <i class="fas fa-user-times"></i> 탈퇴 처리
                        </button>
<%
                } else if (user.getId().equals(session.getAttribute("LOGINED_USER_ID"))) {
%>
                        <span class="badge text-bg-info">본인 계정</span>
<%
                } else if (user.getRole().equals("ADMIN")) {
%>
                    	<span class="badge text-bg-info">ADMIN</span>    
<%
                }
            } else { // 탈퇴된 사용자
%>
                        <button type="button" class="btn btn-sm btn-outline-success" onclick="confirmUserAction('restore', '<%= user.getId() %>', '<%= user.getName() %>')">
                            <i class="fas fa-user-check"></i> 계정 복구
                        </button>
<%
            }
%>
                    </td>
                </tr>
<%
        } // for 루프 끝
    } // else (users 리스트가 비어있지 않은 경우) 끝
%>
            </tbody>
        </table>
    </div>

    <%@ include file="../common/footer.jsp" %>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" ></script>
    <script>
        function confirmUserAction(actionType, userId, userName) {
            let message = "";
            let targetUrlBase = "admin-processUserStatus.jsp?id=" + encodeURIComponent(userId);
            let targetUrl = "";

            if (actionType === 'delete') {
                message = "사용자 '" + userName + " (" + userId + ")' 님을 정말로 탈퇴 처리하시겠습니까?.";
                targetUrl = targetUrlBase + "&action=delete";
            } else if (actionType === 'restore') {
                message = "사용자 '" + userName + " (" + userId + ")' 님의 계정을 정말로 복구하시겠습니까?";
                targetUrl = targetUrlBase + "&action=restore";
            } else {
                return;
            }

            if (confirm(message)) {
                location.href = targetUrl;
            }
        }
    </script>
</body>
</html>