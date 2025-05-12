<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="kr.co.bookhub.vo.Address"%>
<%@page import="kr.co.bookhub.mapper.AddressMapper"%>
<%@page import="kr.co.bookhub.vo.LoanHistory"%>
<%@page import="java.util.Date"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.LoanBookMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%
	/*
		요청 파라미터 없음
			없음
		요청 url
			- bookhub/loan/mypage.jsp
		
		요청 처리 절차
			1. 세션에서 해당 사용자의 아이디를 조회한다.
			2. 사용자의 아이디로 대여한 도서를 조회한다.
			3. 대여내역 페이지에 대여한 도서들을 표현한다.
	*/
	
	String tab = StringUtils.nullToBlank(request.getParameter("tab"));
	
	String id = "hong@gmail.com";
	LoanBookMapper loanBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
	
	List<LoanHistory> returnBooks = loanBookMapper.getReturnBookByUserId(id);
	
    loanBookMapper.updateDelayBooksStatus(id);
	List<LoanHistory> delayBooks = loanBookMapper.getDelayBookByUserId(id);
	
	AddressMapper addressMapper = MybatisUtils.getMapper(AddressMapper.class);
	List<Address> userAddresses = addressMapper.getAllAddressByUserId(id);
	
	   

	int loanPageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	int returnPageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	
	// 대여,연체된 책
	Map<String, Object> loancondition = new HashMap<>();
	
    int loanTotalRows = loanBookMapper.getLoanTotalRows(id);

	Pagination loanPagination = new Pagination(loanPageNo, loanTotalRows, 5);	
	
	loancondition.put("id", id);
    loancondition.put("offset", loanPagination.getOffset());
	loancondition.put("rows", 5);
	List<LoanHistory> sortedloanbooks = loanBookMapper.getSortedLoanBooksByUserId(loancondition);
	
	// 반납한 책
	Map<String,Object> returncondition = new HashMap<>();
	
	int returnTotalRows = loanBookMapper.getReturnTotalRows(id);
	
	Pagination returnPagination = new Pagination(returnPageNo, returnTotalRows, 5);
	
	returncondition.put("id", id);
	loancondition.put("offset", returnPagination.getOffset());
	loancondition.put("rows", 5);
	
	List<LoanHistory> sortedreturnbooks = loanBookMapper.getSortedReturnBooksByUserId(loancondition);
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="home.html">우도도서관</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#">자료검색</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">이용안내</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">문화행사</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">도서관소개</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="login.html">로그아웃</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="#">마이페이지</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- My Page Content -->
    <div class="mypage-container">
        <!-- Profile Section -->
        <div class="profile-section text-center">
            <h3>홍길동님</h3>
            <p class="text-muted">hong@example.com</p>
            <p>회원 등급: <span class="badge bg-primary">일반회원</span></p>
        </div> 

        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link <%="".equals(tab) ? "active" : "" %> " id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab" aria-controls="profile" aria-selected="true">
                    <i class="fas fa-user me-1"></i> 내 정보 수정
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%="rental".equals(tab) ? "active" : "" %>" id="rental-tab" data-bs-toggle="tab" data-bs-target="#rental" type="button" role="tab" aria-controls="rental" aria-selected="false">
                    <i class="fas fa-book me-1"></i> 대여 내역
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%="return".equals(tab) ? "active" : "" %>" id="return-tab" data-bs-toggle="tab" data-bs-target="#return" type="button" role="tab" aria-controls="return" aria-selected="false">
                    <i class="fas fa-undo me-1"></i> 반납 내역
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="wishlist-tab" data-bs-toggle="tab" data-bs-target="#wishlist" type="button" role="tab" aria-controls="wishlist" aria-selected="false">
                    <i class="fas fa-heart me-1"></i> 찜 목록
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="review-tab" data-bs-toggle="tab" data-bs-target="#review" type="button" role="tab" aria-controls="review" aria-selected="false">
                    <i class="fas fa-comment me-1"></i> 내 리뷰/게시글
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%="address".equals(tab) ? "active" : "" %>" id="address-tab" data-bs-toggle="tab" data-bs-target="#address" type="button" role="tab" aria-controls="address" aria-selected="false">
                    <i class="fas fa-map-marker-alt me-1"></i> 주소 관리
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="delete-tab" data-bs-toggle="tab" data-bs-target="#delete" type="button" role="tab" aria-controls="delete" aria-selected="false">
                    <i class="fas fa-user-times me-1"></i> 회원탈퇴
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="myTabContent">
            <!-- Profile Tab -->
            <div class="tab-pane fade <%="".equals(tab) ? "show active" : "" %>" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                <h4 class="mb-4">내 정보 수정</h4>
                <form>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label required">이름</label>
                            <input type="text" class="form-control" id="fullName" value="홍길동" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label required">이메일</label>
                            <input type="email" class="form-control" id="email" value="hong@example.com" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label required">휴대폰 번호</label>
                        <input type="tel" class="form-control" id="phone" value="010-1234-5678" required>
                    </div>

                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">현재 비밀번호</label>
                        <input type="password" class="form-control" id="currentPassword">
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input type="password" class="form-control" id="newPassword">
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" class="form-control" id="confirmPassword">
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn btn-primary">정보 수정</button>
                    </div>
                </form>
            </div>
            
            <!-- Rental Tab -->
            <div class="tab-pane fade <%="rental".equals(tab) ? "show active" : "" %>" id="rental" role="tabpanel" aria-labelledby="rental-tab">
                <h4 class="mb-4">대여 내역</h4>
<%
	if (sortedloanbooks.isEmpty()) {
%>                
                <div class="card mb-3">
                    <div class="card-body text-center">
                      <div class="mb-3">
                        <i class="bi bi-geo-alt-fill fs-1 text-muted"></i>
                      </div>
                      <h5 class="card-title">대여한 책이 없습니다</h5>
                      <p class="card-text text-muted">대여 할 책을 추가해주세요.</p>
                    </div>
                </div>
<%
	}
%>                        

<%
	for (LoanHistory sortedloanbook : sortedloanbooks) {
%>
                <div class="book-item" id="loan-<%=sortedloanbook.getNo()%>">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                        	<a href="detail.jsp?bno=<%=sortedloanbook.getBook().getNo() %>">
                            	<img src="<%=sortedloanbook.getBook().getCoverImagePath()%>"  alt="책 표지" class="book-cover" style="width: 80px; height: 120px; object-fit: cover;">
                            </a>
                        </div>
                        <div class="col-md-5">
                        	<a href="detail.jsp?bno=<%=sortedloanbook.getBook().getNo() %>" 
                        		style="color:black">
	                            <h5><%=sortedloanbook.getBook().getTitle() %></h5>
	                            <p class="text-muted mb-0">저자:<%=sortedloanbook.getBook().getAuthor() %> | 출판사: <%=sortedloanbook.getBook().getPublisher() %></p>
                            </a> 
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: <%=StringUtils.simpleDate(sortedloanbook.getLoanDate()) %></p>
                            <p class="mb-0">반납일: <%=StringUtils.simpleDate(sortedloanbook.getDueDate()) %></p>
                        </div>
                        
<%
	if ("D".equals(sortedloanbook.getLoanStatus())) {
%>
						<div class="col-md-2 text-center">
                            <span class="badge bg-danger status-badge">연체중</span><br/>
                        </div>
<%
	} else {
%>

                       
<%
		if (sortedloanbook.getIsExtension().equals("Y")) {
%>                       
                        <div class="col-md-2 text-center">                        
                            <span class="badge bg-primary status-badge">대여중</span><br/>
                            <span class="badge bg-success status-badge">연장완료</span>
                        </div>
                        <div class="col-md-2">
                        	<a href="return.jsp?lno=<%=sortedloanbook.getNo() %>">
                        		<button class="btn btn-sm btn-outline-primary">반납하기</button>
                        	</a>
                        </div>
<%
		} else if(sortedloanbook.getIsExtension().equals("N")) {
%>  
                        <div class="col-md-2 text-center">
                            <span class="badge bg-primary status-badge">대여중</span><br/>
                        </div>
                        <div class="col-md-2">
                        	<a href="return.jsp?lno=<%=sortedloanbook.getNo() %>">
                        		<button class="btn btn-sm btn-outline-primary mb-2">반납하기</button>
                        	</a>
                            <a href="extension.jsp?lno=<%=sortedloanbook.getNo() %>">
                            	<button class="btn btn-sm btn-outline-primary">연장하기</button>
                            </a>
                        </div>
<%
		}
%>               
<%
	}
%> 
                    </div>
                </div>

<%
	}
%>              
<%
   
   if (loanTotalRows > 0) {
%>
            <!-- Pagination -->
                <nav class="mt-4">
                   <ul id="pagination" class="pagination justify-content-center">
<%
      if (!loanPagination.isFirst()) {
%>
                  		<li class="page-item">
                            <a href="?page=<%=loanPagination.getPrevPage() %>&tab=rental" class="page-link"
                               data-page-no="<%=loanPagination.getPrevPage() %>">이전</a>
                        </li>
<%
   }

      int currentPage = loanPagination.getCurrentPage();
      int beginPage = loanPagination.getBeginPage();
      int endPage = loanPagination.getEndPage();
      for (int num = beginPage; num <= endPage; num++) {
         if (num == currentPage) {
%>   
                  		<li class="page-item active">
                           <span class="page-link"><%=num %></span>
                        </li>
<%
         } else {
%>
                  		<li class="page-item">
                         	<a href="?page=<%=num %>&tab=rental" class="page-link" 
                              data-page-no="<%=num %>"><%=num %></a>
                  		</li>
<%         
         }
      }
      
   if (!loanPagination.isLast()) {
%>
						<li class="page-item <%=loanPagination.isLast() ? "disabled" : "" %>">
						    <a href="?page=<%=loanPagination.getNextPage() %>&tab=rental" class="page-link"
						       data-page-no="<%=loanPagination.getNextPage() %>">다음</a>
						</li>
<%
      }
%>
                    </ul>
                </nav>
<%
   }
%>
            </div>

            <!-- Return Tab -->
            <div class="tab-pane fade <%="return".equals(tab) ? "show active" : "" %>" id="return" role="tabpanel" aria-labelledby="return-tab">
                <h4 class="mb-4">반납 내역</h4>
<%
	if (sortedreturnbooks.isEmpty()) {
%>                
                <div class="card mb-3">
                    <div class="card-body text-center">
                      <div class="mb-3">
                        <i class="bi bi-geo-alt-fill fs-1 text-muted"></i>
                      </div>
                      <h5 class="card-title">반납한 책이 없습니다</h5>
                      <p class="card-text text-muted">반납 할 책을 추가해주세요.</p>
                    </div>
                </div>
<%
	}
%>
                        
<%
	for (LoanHistory sortedreturnbook : sortedreturnbooks) {             
%>               
                <div class="book-item" id="return-<%=sortedreturnbook.getNo()%>">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                        	<a href="detail.jsp?bno=<%=sortedreturnbook.getBook().getNo() %>">
                            	<img src="<%=sortedreturnbook.getBook().getCoverImagePath() %>" alt="책 표지" class="book-cover">
                            </a>
                        </div>
                        <div class="col-md-5">
                        	<a href="detail.jsp?bno=<%=sortedreturnbook.getBook().getNo() %>"
                        		style="color:black">
                            	<h5><%=sortedreturnbook.getBook().getTitle() %></h5>
                            	<p class="text-muted mb-0">저자: <%=sortedreturnbook.getBook().getAuthor() %> | 출판사: <%=sortedreturnbook.getBook().getPublisher() %></p>
                            </a>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: <%=StringUtils.simpleDate(sortedreturnbook.getLoanDate()) %></p>
                            <p class="mb-0">반납일: <%=StringUtils.simpleDate(sortedreturnbook.getDueDate()) %></p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-success status-badge">반납처리중</span>
                        </div>
                        <div class="col-md-2">
                            <span class="text-muted">반납신청: <%=StringUtils.simpleDate(sortedreturnbook.getReturnDate())%></span>
                        </div>
                    </div>
                </div>
<%
	}
%>

<%
   
   if (returnTotalRows > 0) {
%>
            <!-- Pagination -->
                <nav class="mt-4">
                   <ul id="pagination" class="pagination justify-content-center">
<%
      if (!returnPagination.isFirst()) {
%>
                  		<li class="page-item">
                            <a href="?page=<%=returnPagination.getPrevPage() %>&tab=return" class="page-link"
                               data-page-no="<%=returnPagination.getPrevPage() %>">이전</a>
                        </li>
<%
   }

      int currentPage = returnPagination.getCurrentPage();
      int beginPage = returnPagination.getBeginPage();
      int endPage = returnPagination.getEndPage();
      for (int num = beginPage; num <= endPage; num++) {
         if (num == currentPage) {
%>   
                  		<li class="page-item active">
                           <span class="page-link"><%=num %></span>
                        </li>
<%
         } else {
%>
                  		<li class="page-item">
                         	<a href="?page=<%=num %>&tab=return" class="page-link" 
                              data-page-no="<%=num %>"><%=num %></a>
                  		</li>
<%         
         }
      }
      
   if (!returnPagination.isLast()) {
%>
						<li class="page-item <%=returnPagination.isLast() ? "disabled" : "" %>">
						    <a href="?page=<%=returnPagination.getNextPage() %>&tab=return" class="page-link"
						       data-page-no="<%=returnPagination.getNextPage() %>">다음</a>
						</li>
<%
      }
%>
                    </ul>
                </nav>
<%
   }
%>


            </div>
            
            <!-- Wishlist Tab -->
            <div class="tab-pane fade" id="wishlist" role="tabpanel" aria-labelledby="wishlist-tab">
                <h4 class="mb-4">찜 목록</h4>
                
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-0">저자: 이영희 | 출판사: AI출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0"></p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-success status-badge">대출가능</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-primary">대출하기</button>
                        </div>
                    </div>
                </div>

                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>파이썬 데이터 분석</h5>
                            <p class="text-muted mb-0">저자: 박지민 | 출판사: 데이터출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0"></p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-danger status-badge">대출중</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-outline-secondary" disabled>대출중</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Review Tab -->
            <div class="tab-pane fade" id="review" role="tabpanel" aria-labelledby="review-tab">
                <h4 class="mb-4">내 리뷰/게시글</h4>
                
                <!-- Reviews -->
                <h5 class="mb-3">도서 리뷰</h5>
                <div class="review-item">
                    <div class="row">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-11">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-2">저자: 이영희 | 출판사: AI출판사</p>
                            <div class="mb-2">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                            </div>
                            <p>머신러닝을 배우고 싶은 분들에게 추천합니다. 실습 예제가 많아 실제로 적용하기 좋습니다.</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">작성일: 2024-03-15</small>
                                <div>
                                    <button class="btn btn-sm btn-outline-primary me-1">수정</button>
                                    <button class="btn btn-sm btn-outline-danger">삭제</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Posts -->
                <h5 class="mt-4 mb-3">게시글</h5>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>제목</th>
                                <th>작성일</th>
                                <th>조회수</th>
                                <th>댓글수</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>도서관 이용 시간 변경 제안</td>
                                <td>2024-03-10</td>
                                <td>45</td>
                                <td>12</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1">수정</button>
                                    <button class="btn btn-sm btn-outline-danger">삭제</button>
                                </td>
                            </tr>
                            <tr>
                                <td>새로운 도서 구매 요청</td>
                                <td>2024-02-28</td>
                                <td>32</td>
                                <td>8</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1">수정</button>
                                    <button class="btn btn-sm btn-outline-danger">삭제</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Address Management Tab -->
            <div class="tab-pane fade <%="address".equals(tab) ? "show active" : "" %>" id="address" role="tabpanel" aria-labelledby="address-tab">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4>주소 관리</h4>
<%
	if (userAddresses.size() < 4) {
%>
                    <button class="btn btn-primary" onclick="showAddressForm()">주소 추가</button>
<%
	}
%>
                </div>
                
                <!-- Address List View -->
                <div id="addressView">
                    <div class="address-list mb-4">
                        <!-- Default Address Card -->
<%
	if (userAddresses.isEmpty()) {
%>
                        <!-- 배송지가 하나도 없을 때-->
                        <div class="card mb-3">
                            <div class="card-body text-center">
                              <div class="mb-3">
                                <i class="bi bi-geo-alt-fill fs-1 text-muted"></i>
                              </div>
                              <h5 class="card-title">등록된 주소가 없습니다</h5>
                              <p class="card-text text-muted">반납할 주소를 추가해주세요.</p>
                            </div>
                        </div>
<%
	} else {
%>

<%
	for (Address address : userAddresses) {
%>
                        <!-- 배송지가 있을 때-->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h5 class="card-title">
                                            <%=address.getName() %>
<%
		if ("Y".equals(address.getGibon())) {
%>
                                            <span class="badge bg-primary ms-2">기본</span>
<%
		}
%>
                                        </h5>
                                        <p class="mb-1"><%=address.getUser().getName() %></p>
                                        <p class="mb-1"><%=address.getUser().getPhone() %></p>
                                        <p class="mb-1"><%=address.getBasic() %></p>
                                        <p class="mb-0"><%=address.getDetail() %></p>
                                    </div>
                                    <div>
                                        <button class="btn btn-sm btn-outline-primary me-2 edit-btn"
                                        	data-no="<%=address.getNo() %>" 
                                        	data-zipcode="<%=address.getZipcode() %>"
                                        	data-basic="<%=address.getBasic() %>"
                                        	data-detail="<%=address.getDetail() %>"
                                        	data-name="<%=address.getName() %>"
                                        	data-gibon="<%=address.getGibon() %>"
                                        	onclick="showEditAddressForm(<%=address.getNo() %>)">수정</button>
                                    	
<%
		if ("N".equals(address.getGibon())) {
%>                                     
                                        <a href="deleteAddress.jsp?no=<%=address.getNo() %>">
                                        <button class="btn btn-sm btn-outline-danger">삭제</button>
                                      	</a>
<%
	 	}
%>
                                    </div>
                                </div>
                            </div>
                        </div>
<%
	}
%>

<%
	}
%>
                    </div>
                </div>

                <!-- Address Add Form View -->
                <div id="addressAddView" style="display: none;">
                    <form action="insertAddress.jsp" method="post" id="addressAddForm">
                        <div class="mb-3">
                            <label for="zipcode-field" class="form-label">우편번호</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="zipcode-field" name="zipcode" readonly>
                                <button class="btn btn-outline-secondary" type="button" onclick="DaumPostcode('add')">우편번호 검색</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address-field" class="form-label">주소</label>
                            <input type="text" class="form-control" id="address-field" name="basicAddress" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="address-detail-field" class="form-label">상세주소</label>
                            <input type="text" class="form-control" id="address-detail-field" name="addressDetail">
                        </div>
                        
                        <div class="mb-3">
                            <label for="address-name-field" class="form-label">주소별칭</label>
                            <input type="text" class="form-control" id="address-name-field" name="addressName">
                        </div>

                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="is-default-field" name="isGibon"
                                   <%= userAddresses.isEmpty() ? "checked onclick='return false;'" : "" %>>
                                <label class="form-check-label" for="isDefault">
                                    기본 배송지로 설정
                                </label>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <button type="submit" class="btn btn-primary">저장하기</button>
                            <button type="button" class="btn btn-secondary" onclick="hideAddressForm()">취소</button>
                        </div>
                    </form>
                </div>

                <!-- Address Edit Form View -->
                <div id="addressEditView" style="display: none;">
                    <form action="updateAddress.jsp" method="post" id="addressEditForm">
                        <input type="hidden" id="address-edit-no" name="no">
                        <div class="mb-3">
                            <label for="address-edit-zipcode" class="form-label">우편번호</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="address-edit-zipcode" name="zipcode" readonly>
                                <button class="btn btn-outline-secondary" type="button" onclick="DaumPostcode('edit')">우편번호 검색</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address-edit-basic" class="form-label">주소</label>
                            <input type="text" class="form-control" id="address-edit-basic" name="basicAddress" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="address-edit-detail" class="form-label">상세주소</label>
                            <input type="text" class="form-control" id="address-edit-detail" name="addressDetail">
                        </div>
                        
                        <div class="mb-3">
                            <label for="address-edit-name" class="form-label">주소별칭</label>
                            <input type="text" class="form-control" id="address-edit-name" name="addressName">
                        </div>

                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="address-edit-gibon" name="isGibon">
                                <label class="form-check-label" for="address-edit-gibon">
                                    기본 배송지로 설정
                                </label>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2">                        
                            <button type="submit" class="btn btn-primary">수정하기</button>
                            <button type="button" class="btn btn-secondary" onclick="hideAddressForm()">취소</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Delete Account Tab -->
            <div class="tab-pane fade" id="delete" role="tabpanel" aria-labelledby="delete-tab">
                <h4 class="mb-4">회원 탈퇴</h4>
                
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i> 회원 탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.
                </div>
                
                <form>
                    <div class="mb-3">
                        <label for="deletePassword" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" id="deletePassword" required>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="confirmDelete" required>
                            <label class="form-check-label" for="confirmDelete">
                                회원 탈퇴에 동의합니다.
                            </label>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn btn-danger">회원 탈퇴</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer mt-5">
        <div class="container">
            <div class="text-center">
                <small class="text-muted">&copy; 2024 우도도서관. All rights reserved.</small>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
    </script>
    <script>
	    document.addEventListener('DOMContentLoaded', function() {
	        // Initialize any necessary event listeners
	    });
	    
	    $("#addressAddForm").submit(function() {
	    	if($("#zipcode-field").val() == "") {
	    		alert("우편번호를 입력하세요.");
	    		$("#zipcode-field").focus();
	    		return false;
	    	}
	    	if($("#address-detail-field").val() == "") {
	    		alert("상세주소를 입력하세요.");
	    		$("#address-detail-field").focus();
	    		return false;
	    	}
	    	if($("#address-name-field").val() == "") {
	    		alert("주소 별칭을 입력하세요.");
	    		$("#address-name-field").focus();
	    		return false;
	    	}
	    })
	    
	    $("#addressEditForm").submit(function() {
	    	if($("#address-edit-zipcode").val() == "") {
	    		alert("우편번호를 입력하세요.");
	    		$("#address-edit-zipcode").focus();
	    		return false;
	    	}
	    	if($("#address-edit-detail").val() == "") {
	    		alert("상세주소를 입력하세요.");
	    		$("#address-edit-detail").focus();
	    		return false;
	    	}
	    	if($("#address-edit-name").val() == "") {
	    		alert("주소 별칭을 입력하세요.");
	    		$("#address-edit-name").focus();
	    		return false;
	    	}
	    })
	    
	    function showEditAddressForm(addressNo) {
	        const addressView = document.getElementById('addressView');
	        const addressAddView = document.getElementById('addressAddView');
	        const addressEditView = document.getElementById('addressEditView');
	        const addressBtn = $(`button[data-no="\${addressNo}"]`);

	        const zipcode = addressBtn.data('zipcode');
	        const basicAddress = addressBtn.data('basic');
	        const detailAddress = addressBtn.data('detail');
	        const addressName = addressBtn.data('name');
	        const isGibon = addressBtn.data('gibon');

	        // 폼 필드에 값 채우기
	        $('#address-edit-no').val(addressNo);
	        $('#address-edit-zipcode').val(zipcode);
	        $('#address-edit-basic').val(basicAddress);
	        $('#address-edit-detail').val(detailAddress);
	        $('#address-edit-name').val(addressName);
	        $('#address-edit-gibon').prop('checked', isGibon === 'Y');

	        const gibonCheckbox = $('#address-edit-gibon');
	        if (isGibon === 'Y') {
	            gibonCheckbox.prop('checked', true);
	            gibonCheckbox.prop('disabled', true); // 기본 배송지일 경우 비활성화
	        } else {
	            gibonCheckbox.prop('checked', false);
	            gibonCheckbox.prop('disabled', false); // 일반 주소일 경우 활성화
	        }
	        
	        // 주소 목록 숨기고 수정 폼 표시
	        addressView.style.display = 'none';
	        addressAddView.style.display = 'none';
	        addressEditView.style.display = 'block';
	    }
	    
	    function showAddressForm() {
	        const addressView = document.getElementById('addressView');
	        const addressAddView = document.getElementById('addressAddView');
	        const addressEditView = document.getElementById('addressEditView');
	        
	        // 폼 초기화
	        $('#addressAddForm')[0].reset();
	        
	        // 주소 목록 숨기고 추가 폼 표시
	        addressView.style.display = 'none';
	        addressAddView.style.display = 'block';
	        addressEditView.style.display = 'none';
	    }
	    
	    function hideAddressForm() {
	        const addressView = document.getElementById('addressView');
	        const addressAddView = document.getElementById('addressAddView');
	        const addressEditView = document.getElementById('addressEditView');
	        
	        addressView.style.display = 'block';
	        addressAddView.style.display = 'none';
	        addressEditView.style.display = 'none';
	    }
	    
	    function DaumPostcode(mode) {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                var addr = '';     // 주소 변수
	                var extraAddr = ''; // 참고항목 변수

	                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { 
	                    addr = data.roadAddress;
	                } else { 
	                    addr = data.jibunAddress;
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                if (mode === 'add') {
	                    document.getElementById('zipcode-field').value = data.zonecode;
	                    document.getElementById('address-field').value = addr;
	                    document.getElementById('address-detail-field').focus();
	                } else if (mode === 'edit') {
	                    document.getElementById('address-edit-zipcode').value = data.zonecode;
	                    document.getElementById('address-edit-basic').value = addr;
	                    document.getElementById('address-edit-detail').focus();
	                }
	            }
	        }).open();
	    }
	</script>
</body>
</html> 