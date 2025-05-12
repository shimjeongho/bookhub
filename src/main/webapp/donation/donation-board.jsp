<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.vo.Donation"%>
<%@page import="kr.co.bookhub.mapper.DonationMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int pageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	
	//DonationMapper 구현객체 획득
	DonationMapper donationMapper = MybatisUtils.getMapper(DonationMapper.class);
	
	Map<String, Object> condition = new HashMap<>();
	
	int totalRows = donationMapper.getTotalRows();
	
	Pagination pagination = new Pagination(pageNo, totalRows, 10);

	condition.put("offset", pagination.getOffset());
	condition.put("rows", 10);
	
	// 기부 도서 리스트 조회
	List<Donation> donations = donationMapper.getAllDonation(condition);
	
	// 도서관 리스트 조회
	List<Library> libraries = donationMapper.getAllLibrary();
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 기증 목록 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <%@ include file="../common/nav.jsp" %>
    
    <!-- Board Content -->
    <div class="board-container">
        <!-- Board Header -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h4 class="card-title mb-0">책 기부 목록</h4>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-end gap-2">
                            <!-- 옵션 및 검색 부분이다. 시간 남으면 할 예정 - 한지완
                            <div class="input-group" style="max-width: 300px;">
                                <select class="form-select" style="max-width: 100px;">
                                    <option selected>제목</option>
                                    <option>내용</option>
                                    <option>작성자</option>
                                </select>
                                <input type="text" class="form-control" placeholder="검색어를 입력하세요">
                                <button class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div> -->
                            <a href="donation-form.jsp" class="btn btn-primary">
                                <i class="fas fa-pen"></i> 기부하기
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Post List -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="text-center" style="width: 80px;">번호</th>
                                <th scope="col">책 제목</th>
                                <th scope="col" class="text-center">기부자</th>
                                <th scope="col" class="text-center">기부일자</th>
                                <th scope="col" class="text-center">도서관</th>
                            </tr>
                        </thead>
                        <tbody>
<%
	for (Donation donation : donations) {
		int no = donation.getNo();
%>
							<tr>
							    <td class="text-center"><%=no %></td>
							    <td>
							        <a 
							            data-bs-toggle="collapse"
							            href="#collapseDesc<%=no%>"
							            role="button"
							            aria-expanded="false"
							            aria-controls="collapseDesc<%=no%>"
							            class="text-dark text-decoration-none fw-semibold"
							        >
							            <%=donation.getTitle() %>
							        </a>
							    </td>
							    <td class="text-center"><%=donation.getUser().getId() %></td>
							    <td class="text-center"><%=StringUtils.simpleDate(donation.getUpdatedDate()) %></td>
							    <td class="text-center"><%=libraries.get(donation.getLibrary().getNo()).getName() %></td>
							</tr>
							<tr class="collapse-row">
							    <td colspan="5" class="p-0 border-0">
							        <div class="collapse" id="collapseDesc<%=no%>">
							            <div class="p-3 bg-light text-muted border-top">
							                📖 <%=donation.getDescription() %>
							            </div>
							        </div>
							    </td>
<%
	}
%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Pagination -->
<%
	if (totalRows > 0) {
		int prevPage = pagination.getPrevPage();
		int nextPage = pagination.getNextPage();
		int currentPage = pagination.getCurrentPage();
		int beginPage = pagination.getBeginPage();
		int endPage = pagination.getEndPage();
%>
                <nav class="mt-4">
                    <ul class="pagination justify-content-center" id="pagenation-search">
<%
	if (!pagination.isFirst()) {
%>
                        <li class="page-item <%=pagination.isFirst() ? "disabled" : "" %>">
                            <a class="page-link" href="donation-board.jsp?page=<%=prevPage %>" data-page-no="<%=prevPage %>">이전</a>
                        </li>
<%
	}
%>
<%
	for (int num = beginPage; num <= endPage; num++) {
%>
                        <li class="page-item <%=pageNo == num ? "active" : "" %>">
                        <a class="page-link" href="donation-board.jsp?page=<%=num %>" data-page-no="<%=num %>"><%=num %></a>
                        </li>
<%
	}

		if (!pagination.isLast()) {
%>
                        <li class="page-item <%=pagination.isLast() ? "disabled" : "" %>">
                            <a class="page-link" href="donation-board.jsp?page=<%=nextPage %>" data-page-no="<%=nextPage %>">다음</a>
                        </li>
                    </ul>
                </nav>
<%
		}
	}
%>
    </div>

    <!-- Footer -->
    <%@ include file="../common/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</body>
</html>