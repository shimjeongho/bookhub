<%@page import="kr.co.bookhub.vo.User"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.vo.LoanHistory"%>
<%@page import="kr.co.bookhub.mapper.LoanBookMapper"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String adminRole = (String) session.getAttribute("LOGINED_USER_ROLE");
    if (!"ADMIN".equals(adminRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=auth_admin_required");
        return;
    }

    LoanBookMapper loanMapper = MybatisUtils.getMapper(LoanBookMapper.class);
    List<LoanHistory> pendingReturns = loanMapper.tempGetAllPendingReturns();

    String processStatus = request.getParameter("process_status");
    String processMsg = request.getParameter("msg");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>도서 반납 관리 - 북허브</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../resources/css/styles.css" rel="stylesheet">
    <style>
        .table th, .table td {
            vertical-align: middle !important; /* 모든 셀 수직 가운데 정렬 */
            padding: 0.5rem 0.5rem; /* 셀 내부 패딩 줄이기 (기본값 0.75rem) */
        }
        .truncate-text {
            display: inline-block;
            max-width: 200px;  /* 도서명 최대 너비 조정 (더 줄여도 됨) */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        /* 버튼 스타일 수정 */
        .btn-return-process {
            padding: 0.25rem 0.5rem; /* 버튼 내부 패딩 줄이기 */
            font-size: 0.875rem;    /* 버튼 폰트 크기 줄이기 */
            min-width: auto;        /* 버튼 최소 너비 자동 (텍스트 길이에 맞춤) */
        }
        /* 테이블 헤더 텍스트 왼쪽 정렬 (필요에 따라) */
        .table thead th {
            text-align: left;
        }
        /* 특정 컬럼들 텍스트 가운데 정렬 */
        .table .text-center-data {
            text-align: center;
        }
    </style>
</head>
<body>
    <%@ include file="../common/nav.jsp" %>

    <div class="container mt-5 min-vh-100">
        <h1>도서 반납 관리 <span class="badge bg-warning text-dark">반납 처리 중</span></h1>
        <p class="text-muted">사용자가 반납 신청한 도서 목록입니다. 실제 도서 수령 후 '반납 완료 처리'를 진행해주세요.</p>
        <div class="mb-3 text-info small">
            <i class="fas fa-info-circle"></i> 
        </div>
        <hr>

        <% if ("success".equals(processStatus) && processMsg != null && !processMsg.isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= processMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("error".equals(processStatus) && processMsg != null && !processMsg.isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>오류:</strong> <%= processMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="table-responsive">
            <table class="table table-hover align-middle table-bordered w-100"> 
                <thead class="table-light">
                    <tr>
                        <th scope="col" style="width: 7%;">대출번호</th>
                        <th scope="col" style="width: 7%;">도서번호</th>
                        <th scope="col" style="width: 23%;">도서명</th>
                        <th scope="col" style="width: 10%;">도서관명</th>
                        <th scope="col" style="width: 15%;">사용자ID</th>
                        <th scope="col" style="width: 10%;">대출일</th>
                        <th scope="col" style="width: 10%;">반납예정일</th>
                        <th scope="col" style="width: 10%;">반납신청일</th>
                        <th scope="col" style="width: 8%; text-align: center;">관리</th>
                    </tr>
                </thead>
                <tbody>
                <% if (pendingReturns == null || pendingReturns.isEmpty()) { %>
                    <tr>
                        <td colspan="9" class="text-center py-4"> 
                            <p class="mb-0 text-muted">현재 반납 처리 중인 도서가 없습니다.</p>
                        </td>
                    </tr>
                <% } else {
                    for (LoanHistory loan : pendingReturns) {
                        Book book = loan.getBook();
                        User user = loan.getUser();
                        Library library = loan.getLibrary();

                        String lnoStr = String.valueOf(loan.getNo());
                        String bnoStr = (book != null && book.getNo() != 0) ? String.valueOf(book.getNo()) : "";
                        String libNoStr = (library != null && library.getNo() != 0) ? String.valueOf(library.getNo()) : ""; // 이 값은 JS로만 전달
                        String libraryName = (library != null && library.getName() != null) ? library.getName() : "-";

                        String bookTitle = (book != null && book.getTitle() != null) ? book.getTitle() : "정보 없음";
                        String userId = (user != null && user.getId() != null) ? user.getId() : "정보 없음";
                        String loanDateStr = (loan.getLoanDate() != null) ? sdf.format(loan.getLoanDate()) : "-";
                        String dueDateStr = (loan.getDueDate() != null) ? sdf.format(loan.getDueDate()) : "-";
                        String returnDateStr = (loan.getReturnDate() != null) ? sdf.format(loan.getReturnDate()) : "-";

                        String bookTitleForJs = bookTitle.replace("'", "\\'");
                %>
                    <tr>
                        <td class="text-center-data"><%= lnoStr %></td>
                        <td class="text-center-data"><%= bnoStr %></td>
                        <td>
                            <span class="truncate-text" title="<%= bookTitle %>"><%= bookTitle %></span>
                        </td>
                        <td><%= libraryName %></td>
                        <td><%= userId %></td>
                        <td class="text-center-data"><%= loanDateStr %></td>
                        <td class="text-center-data"><%= dueDateStr %></td>
                        <td class="text-center-data"><%= returnDateStr %></td>
                        <td class="text-center"> 
                            <button type="button" class="btn btn-primary btn-return-process"
                                onclick="confirmBookReturn('<%= lnoStr %>', '<%= bnoStr %>', '<%= libNoStr %>', '<%= bookTitleForJs %>')">
                                반납처리
                            </button>
                        </td>
                    </tr>
                <%  }
                   } %>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="../common/footer.jsp" %>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" ></script>
    <script>
        function confirmBookReturn(lno, bno, libNo, bookTitle) {
            const title = bookTitle || "해당 도서";
            if (confirm("도서 '" + title + "' (대출번호: " + lno + ")의 반납을 완료 처리하시겠습니까?")) {
                let targetUrl = "/bookhub/loan/returnSuccess.jsp";
                targetUrl += "?loanNo=" + encodeURIComponent(lno);
                targetUrl += "&bno=" + encodeURIComponent(bno);
                targetUrl += "&libNo=" + encodeURIComponent(libNo);
                location.href = targetUrl;
            }
        }
    </script>
</body>
</html>