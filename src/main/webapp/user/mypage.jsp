<%@page import="kr.co.bookhub.mapper.StockMapper"%>
<%@page import="kr.co.bookhub.mapper.BookMapper"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="kr.co.bookhub.vo.Address"%>
<%@page import="kr.co.bookhub.mapper.AddressMapper"%>
<%@page import="kr.co.bookhub.vo.LoanHistory"%>
<%@page import="java.util.Date"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="java.util.List"%>
<%@ page import="kr.co.bookhub.vo.User" %>
<%@ page import="kr.co.bookhub.mapper.UserMapper" %>
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
	
	// 세션이 없을때 로그인 창으로 리다이랙션
	String userId = (String)session.getAttribute("LOGINED_USER_ID");
    String userName = (String)session.getAttribute("LOGINED_USER_NAME");
    String userPhone = (String)session.getAttribute("LOGINED_USER_PHONE");

    if (userId == null) {
        // 로그인되지 않은 경우 처리
        response.sendRedirect("signin.jsp?error=auth");
        return;
    }
    
	
	String tab = StringUtils.nullToBlank(request.getParameter("tab"));
	
	
	LoanBookMapper loanBookMapper = MybatisUtils.getMapper(LoanBookMapper.class);
    loanBookMapper.updateDelayBooksStatus(userId);
	
	AddressMapper addressMapper = MybatisUtils.getMapper(AddressMapper.class);
	List<Address> userAddresses = addressMapper.getAllAddressByUserId(userId);
	
	int loanPageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	int returnPageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	
	// 대여,연체된 책
	Map<String, Object> loancondition = new HashMap<>();
    int loanTotalRows = loanBookMapper.getLoanTotalRows(userId);
    
	Pagination loanPagination = new Pagination(loanPageNo, loanTotalRows, 5);	
	loancondition.put("id", userId);
    loancondition.put("offset", loanPagination.getOffset());
	loancondition.put("rows", 5);
	
	List<LoanHistory> sortedloanbooks = loanBookMapper.getSortedLoanBooksByUserId(loancondition);
	
	// 반납한 책
	Map<String,Object> returncondition = new HashMap<>();
	int returnTotalRows = loanBookMapper.getReturnTotalRows(userId);
	
	Pagination returnPagination = new Pagination(returnPageNo, returnTotalRows, 5);
	returncondition.put("id", userId);
	loancondition.put("offset", returnPagination.getOffset());
	loancondition.put("rows", 5);
	
	List<LoanHistory> sortedreturnbooks = loanBookMapper.getSortedReturnBooksByUserId(loancondition);
	
	// 책 정보 조회
	BookMapper bookMapper = MybatisUtils.getMapper(BookMapper.class);
	List<Book> books = bookMapper.getMyWishListBooks(userId);
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
    <%@ include file="../common/nav.jsp" %>

    <!-- My Page Content -->
    <div class="mypage-container">
        <!-- Profile Section -->
        <div class="profile-section text-center">
            <h3><%= userName %>님</h3>
            <p class="text-muted"><%= userId %></p>
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
                <button class="nav-link <%="address".equals(tab) ? "active" : "" %>" id="address-tab" data-bs-toggle="tab" data-bs-target="#address" type="button" role="tab" aria-controls="address" aria-selected="false">
                    <i class="fas fa-map-marker-alt me-1"></i> 주소 관리
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link <%="fail".equals(tab) ? "active" : "" %>" id="delete-tab" data-bs-toggle="tab" data-bs-target="#delete" type="button" role="tab" aria-controls="delete" aria-selected="false">
                    <i class="fas fa-user-times me-1"></i> 회원탈퇴
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="myTabContent">
            <!-- Profile Tab -->
            <div class="tab-pane fade <%="".equals(tab) ? "show active" : "" %>" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                <h4 class="mb-4">내 정보 수정</h4>
                <form id="profile" action="update-profile.jsp" method="post">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label required">이름</label>
                            <input type="text" class="form-control" id="fullName" name="name" value="<%= userName %>" >
                            <div id="fullNameError" class="form-text mt-1"></div>
                        </div>
                 
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label required">휴대폰 번호</label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="<%= userPhone %>" >
                        <div id="phoneError" class="form-text mt-1"></div>
                    </div>


                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">현재 비밀번호</label>
                        <input type="password" class="form-control" name="password" id="currentPassword">
                        <div id="currentPasswordError" class="form-text mt-1"></div>
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input type="password" class="form-control" name="newPassword" id="newPassword">
                        <div id="newPasswordError" class="form-text mt-1"></div>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword">
                        <div id="confirmPasswordError" class="form-text mt-1"></div>
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
                        	<a href="/bookhub/book/detail.jsp?bno=<%=sortedloanbook.getBook().getNo() %>">
                            	<img src="<%=sortedloanbook.getBook().getCoverImagePath()%>"  alt="책 표지" class="book-cover" style="width: 80px; height: 120px; object-fit: cover;">
                            </a>
                        </div>
                        <div class="col-md-5">
                        	<a href="/bookhub/book/detail.jsp?bno=<%=sortedloanbook.getBook().getNo() %>" 
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
                        <div class="col-md-2">
                        		<button class="btn btn-sm btn-outline-primary"
                        			onclick="confirmReturn('<%=sortedloanbook.getNo() %>')">반납하기</button>
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
                        		<button class="btn btn-sm btn-outline-primary"
                        			onclick="confirmReturn('<%=sortedloanbook.getNo() %>')">반납하기</button>
                        </div>
<%
		} else if(sortedloanbook.getIsExtension().equals("N")) {
%>  
                        <div class="col-md-2 text-center">
                            <span class="badge bg-primary status-badge">대여중</span><br/>
                        </div>
                        <div class="col-md-2">
                        		<button class="btn btn-sm btn-outline-primary mb-2"
                        			onclick="confirmReturn('<%=sortedloanbook.getNo() %>')">반납하기</button>
                            	<button class="btn btn-sm btn-outline-primary" 
                            		onclick="confirmExtension('<%=sortedloanbook.getNo() %>')">연장하기</button>
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
                        	<a href="/bookhub/book/detail.jsp?bno=<%=sortedreturnbook.getBook().getNo() %>">
                            	<img src="<%=sortedreturnbook.getBook().getCoverImagePath() %>" alt="책 표지" class="book-cover">
                            </a>
                        </div>
                        <div class="col-md-5">
                        	<a href="/bookhub/book/detail.jsp?bno=<%=sortedreturnbook.getBook().getNo() %>"
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


<%
    String basePath = request.getContextPath() + "/book/detail.jsp?bno=";

    for (Book book : books) {
        String detailUrl = basePath + book.getNo();
%>
    <a href="<%= detailUrl %>" class="book-item-link" style="text-decoration: none; color: inherit;">
        <div class="book-item">
            <div class="row align-items-center">
                <div class="col-md-1">
                    <img src="<%= book.getCoverImagePath() %>" alt="책 표지" class="book-cover">
                </div>
                <div class="col-md-5">
                    <h5><%= book.getTitle() %></h5>
                    <p class="text-muted mb-0">저자: <%= book.getAuthor() %> | 출판사: <%= book.getPublisher() %></p>
                </div>
                <div class="col-md-2">
                    <p class="mb-0"></p>
                </div>
            </div>
        </div>
    </a>
<%
    }
%>
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
                                        <button class="btn btn-sm btn-outline-danger"
                                        	onclick="confirmDelete('<%=address.getNo() %>')">삭제</button>
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
                    <form action="/bookhub/loan/insertAddress.jsp" method="post" id="addressAddForm">
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
                    <form action="/bookhub/loan/updateAddress.jsp" method="post" id="addressEditForm">
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
            <div class="tab-pane fade <%="fail".equals(tab) ? "show active" : "" %>" id="delete" role="tabpanel" aria-labelledby="delete-tab">
                <h4 class="mb-4">회원 탈퇴</h4>
                
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i> 회원 탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.
                </div>
                
                <form id="delete" action="delete-user.jsp" method="post">
                    <div class="mb-3">
                        <label for="deletePassword" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" id="deletePassword" name="deletePassword" required>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="confirmDelete" name="confirmDelete" value="agree" required>
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
    <%@ include file="../common/footer.jsp" %>
    
    <!-- Bootstrap Modal (업데이트 성공) -->
	<div class="modal fade" id="updateSuccessModal" tabindex="-1" aria-labelledby="updateSuccessModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="updateSuccessModalLabel">회원정보 수정완료</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body" id="updateSuccessModalMessage">
	                <!-- 에러 메시지가 여기에 표시됩니다. -->
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	            </div>
	        </div>
	    </div>
	</div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
    </script>
    <script>
	    $(document).ready(function() {
			const $fullNameInput = $('#fullName');
			const $fullNameError = $('#fullNameError');
			const $phoneInput = $('#phone');
			const $phoneError = $('#phoneError');
			const $passwordInput = $('#currentPassword');
			const $passwordError = $('#currentPasswordError');
			const $newPasswordInput = $('#newPassword');
			const $newPasswordError = $('#newPasswordError');
			const $confirmPasswordInput = $('#confirmPassword');
			const $confirmPasswordError = $('#confirmPasswordError');
			
			//bootstrap 모달객체 미리 생성
			const updateSuccessModal = new bootstrap.Modal(document.getElementById('updateSuccessModal'));
			const $updateSuccessModalMessage = $('#updateSuccessModalMessage');        
	        const $updateSuccessModalLabel = $('#updateSuccessModalLabel');
			
			$('#profile').on('submit', function(event) {
				event.preventDefault();
				console.log('폼제출이 시도되었습니다');
				
				$fullNameInput.removeClass('is-invalid');
				$fullNameError.text('').removeClass('text-danger');   			
				$phoneInput.removeClass('is-invalid');
				$phoneError.text('').removeClass('text-danger');   			
				$passwordInput.removeClass('is-invalid');
				$passwordError.text('').removeClass('text-danger');   			
				$newPasswordInput.removeClass('is-invalid');
				$newPasswordError.text('').removeClass('text-danger');   			
				$confirmPasswordInput.removeClass('is-invalid');
				$confirmPasswordError.text('').removeClass('text-danger');   			
				
				const fullNameValue = $fullNameInput.val().trim();
				const phoneValue = $phoneInput.val();
				const passwordValue = $passwordInput.val();
				const newPasswordValue = $newPasswordInput.val();
				const confirmPasswordValue = $confirmPasswordInput.val();
				
				let isValid = true;
				
				if (fullNameValue==="") {
					$fullNameInput.addClass('is-invalid');
					$fullNameError.text('이름을 입력해 주세요.').addClass('text-danger');
					isValid = false;
				}
				if (phoneValue==="") {
					$phoneInput.addClass('is-invalid');
					$phoneError.text('전화번호를 입력해 주세요.').addClass('text-danger');
					isValid = false;
				}
				
				const passwordChangeAttempt = passwordValue !== "" || newPasswordValue !== "" || confirmPasswordValue !== "";
				
	   			 if (passwordChangeAttempt) {
	   		            // 현재 비밀번호: 공백 검사
	   		            if (passwordValue === "") {
	   		                $passwordInput.addClass('is-invalid');
	   		                $passwordError.text('현재 비밀번호를 입력해주세요.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		            // 새 비밀번호: 공백 검사
	   		            if (newPasswordValue === "") {
	   		                $newPasswordInput.addClass('is-invalid');
	   		                $newPasswordError.text('새 비밀번호를 입력해주세요.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		            // 새 비밀번호 확인: 공백 검사
	   		            if (confirmPasswordValue === "") {
	   		                $confirmPasswordInput.addClass('is-invalid');
	   		                $confirmPasswordError.text('새 비밀번호 확인을 입력해주세요.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		            // 새 비밀번호와 확인 일치 여부 (공백이 아닐 때만 비교)
	   		            if (newPasswordValue !== "" && confirmPasswordValue !== "" && newPasswordValue !== confirmPasswordValue) {
	   		                $confirmPasswordInput.addClass('is-invalid');
	   		                $confirmPasswordError.text('새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		        }
				
				if (!isValid) {
					if ($fullNameInput.hasClass('is-invalid')) $fullNameInput.focus();
		            else if ($phoneInput.hasClass('is-invalid')) $phoneInput.focus();
		            else if ($passwordInput.hasClass('is-invalid')) $passwordInput.focus();
		            else if ($newPasswordInput.hasClass('is-invalid')) $newPasswordInput.focus();
		            else if ($confirmPasswordInput.hasClass('is-invalid')) $confirmPasswordInput.focus();
		            return; // AJAX 요청 보내지 않음
		        }
	            
				console.log('클라이언트 유효성 검사 통과')
				
				const dataToSend = {
	            		fullName: fullNameValue,
	            		phone: phoneValue,
	            		password: passwordValue,
	            		newPassword: newPasswordValue,
	            		confirmPassword: confirmPasswordValue
	            };
	            
				$.ajax({
		            url: 'update-profile.jsp',
		            type: 'POST',
		            data: dataToSend,
		            dataType: 'json',
		            success: function(responseFromServer) {
		                console.log('ajax요청 성공', responseFromServer);
		                if (responseFromServer.success) {
		                    $updateSuccessModalLabel.text('정보 수정 완료');
		                    $updateSuccessModalMessage.text(responseFromServer.message);
		                    updateSuccessModal.show();
		                    if (passwordChangeAttempt) {
		                        $passwordInput.val('');
		                        $newPasswordInput.val('');
		                        $confirmPasswordInput.val('');
		                    }
		                    $('.profile-section h3').text(nameValue + '님');
		                } else {
		                    // 서버로부터 받은 에러 메시지를 해당 필드 아래에 표시 (if-else if 사용)
		                    let $errorFieldInput = null;
		                    let $errorFieldMessageElement = null; // 변수명 변경하여 명확화
	
		                    if (responseFromServer.errorField) {
		                        const errorField = responseFromServer.errorField;
	
		                        if (errorField === "name") {
		                            $errorFieldInput = $fullNameInput;
		                            $errorFieldMessageElement = $fullNameError;
		                        } else if (errorField === "phone") {
		                            $errorFieldInput = $phoneInput;
		                            $errorFieldMessageElement = $phoneError;
		                        } else if (errorField === "password") { // 현재 비밀번호
		                            $errorFieldInput = $passwordInput;
		                            $errorFieldMessageElement = $passwordError;
		                        } else if (errorField === "newPassword") {
		                            $errorFieldInput = $newPasswordInput;
		                            $errorFieldMessageElement = $newPasswordError;
		                        } else if (errorField === "confirmPassword") {
		                            $errorFieldInput = $confirmPasswordInput;
		                            $errorFieldMessageElement = $confirmPasswordError;
		                        } else if (errorField === "auth") {
		                            alert(responseFromServer.message);
		                            window.location.href = "signin.jsp?error=auth_required";
		                            return; // 추가 처리 중단
		                        }
	
		                        if ($errorFieldInput && $errorFieldMessageElement) {
		                            $errorFieldInput.addClass('is-invalid').focus();
		                            $errorFieldMessageElement.text(responseFromServer.message).addClass('text-danger');
		                        } else {
		                            // errorField가 있지만 위 case에 해당하지 않는 경우 (예상치 못한 값)
		                            $updateSuccessModalLabel.text('정보 수정 실패');
		                            $updateSuccessModalMessage.text(responseFromServer.message || "정보 수정 중 오류가 발생했습니다.");
		                            updateSuccessModal.show();
		                        }
		                    } else {
		                        // errorField 자체가 없는 실패 응답
		                        $updateSuccessModalLabel.text('정보 수정 실패');
		                        $updateSuccessModalMessage.text(responseFromServer.message || "알 수 없는 오류가 발생했습니다.");
		                        updateSuccessModal.show();
		                    }
		                }
		            },
		            error: function(jqXHR, textStatus, earrorThrown) {
		                console.log('ajax요청 실패', textStatus, '오류:', errorThrown);
						console.error("서버 응답 내용:", jqXHR.responseText); // 서버가 보낸 에러 메시지 확인
		                $updateSuccessModalLabel.text('요청 처리 오류');
		                $updateSuccessModalMessage.text('서버와의 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
		                updateSuccessModal.show();
		            }
		        });
		        console.log('ajax요청을 보냈습니다.');
				
			});//이벤트발생
			const urlParams = new URLSearchParams(window.location.search);
		    const deleteStatus = urlParams.get('delete_status');
		    // 'tab' 파라미터도 확인하여, 정확히 'delete' 탭으로 리다이렉션 되었을 때만 alert
		    const currentTab = urlParams.get('tab');
	
		    if (deleteStatus === 'password_mismatch' && currentTab === 'delete') {
		        alert("비밀번호가 일치하지 않습니다.");
		    }
		});//페이지 준비완료
    
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
	    
	    function confirmDelete(no) {
	    	var result = confirm("해당 주소를 삭제하시겠습니까?");
	    	if (result) {
	    		location.href = "/bookhub/loan/deleteAddress.jsp?no=" + no;
	    	}
	    }
	    
	    function confirmExtension(lno) {
	    	var result = confirm("해당 도서를 연장하시겠습니까?");
	    	if (result) {
	    		location.href = "/bookhub/loan/extension.jsp?lno=" + lno;
	    	}
	    }
	    
	    function confirmReturn(lno) {
	    	var result = confirm("해당 도서를 반납하시겠습니까?");
	    	if (result) {
	    		location.href = "/bookhub/loan/return.jsp?lno=" + lno;
	    	}
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