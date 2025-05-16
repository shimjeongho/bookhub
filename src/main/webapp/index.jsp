<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.mapper.DonationMapper"%>
<%@page import="kr.co.bookhub.mapper.RecommendBooksMapper"%>
<%@page import="kr.co.bookhub.vo.Donation"%>
<%@page import="kr.co.bookhub.mapper.IndexPageMapper"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//BookMapper 구현객체 획득
	IndexPageMapper indexPageMapper = MybatisUtils.getMapper(IndexPageMapper.class);
	RecommendBooksMapper recommendBooksMapper = MybatisUtils.getMapper(RecommendBooksMapper.class);

	// 추천 도서 관련
	String userId = (String)session.getAttribute("LOGINED_USER_ID");
	
	// 로그인 유저 대여 목록 개수 가져오기(로그인 상태가 아닐 시 0)
	int userLoanAndWishlistCnt = 0;
	
	if (userId != null) {
		userLoanAndWishlistCnt = recommendBooksMapper.getTotalLoanHistoryAndWishlistRows(userId);
	}
	
	// 맞춤 도서 가져오기
	List<Book> recommendBooks = recommendBooksMapper.getRecommendBooksByUserId(userId, userLoanAndWishlistCnt);
	
	// 최신 출시된 20개 도서 조회
	List<Book> recentBooks = indexPageMapper.getBooksForIndexPage();
	
	// 최신 기증된 20개 도서 조회
	List<Donation> donationBooks = indexPageMapper.getDonationBooksForIndexPage();
	
	// DonationMapper 구현객체 획득
		DonationMapper donationMapper = MybatisUtils.getMapper(DonationMapper.class);
		
	// 도서관 리스트 조회
	List<Library> libraries = donationMapper.getAllLibrary();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>북허브</title>
    <!-- Google Fonts - Noto Sans KR -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="resources/css/styles.css" rel="stylesheet">
</head>
<body>
	<%@ include file="../common/nav.jsp" %>
	
	<!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 mb-4">북허브에 오신 것을 환영합니다</h1>
            <p class="lead mb-4">지식과 문화가 함께하는 공간</p>
            <!-- Search Header -->
            <form id="form-condition"
				method="get"
				action="/bookhub/search/search.jsp">
			
		    <input type="hidden" name="page" value="1" />
		     
    <header class="">
        <div class="container">
        	<div class="row justify-content-center">
                        <div class="col-md-8">
                    <div class="card shadow-sm">
                        <div class="card-body">
                            <div class="row g-3 align-items-center">
                                <!-- AI Search Radio Buttons -->
                                <div class="col-md-3">
                                    <div class="btn-group w-100" role="group" style="height: 38px;">
                                        <input type="radio" class="btn-check" name="ai" id="standard-search" value="N" checked>
                                        <label class="btn btn-outline-primary rounded-0" for="standard-search" style="border-radius: 0.375rem 0 0 0.375rem !important;">
                                            <i class="fas fa-search me-1"></i>
                                        </label>
                                        
                                        <input type="radio" class="btn-check" name="ai" id="ai-search" value="O">
                                        <label class="btn btn-outline-primary rounded-0" for="ai-search" style="border-radius: 0 0.375rem 0.375rem 0 !important;">
                                            <i class="fas fa-robot me-1"></i>
                                        </label>
                                    </div>
                                </div>

                                <!-- Category Select -->
                                <div class="col-md-3">
                                    <select class="form-select" name="category" style="height: 38px;">
                                        <option value="title" selected>제목</option>
                                        <option value="author">저자</option>
                                        <option value="publisher">출판사</option>
                                        <option value="isbn">ISBN</option>
                                    </select>
                                </div>

                                <!-- Search Bar -->
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <input type="search" 
                                            id="search-bar"
                                            class="form-control"
                                            placeholder="검색어를 입력하세요"
                                            name="search"
                                            maxlength="100" style="height: 38px;">
                                        <button class="btn btn-primary" type="submit" style="height: 38px;">
                                            <i class="fas fa-search me-1"></i>검색
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    </form>
        </div>
    </section>

    <!-- Latest Books Carousel Section -->
    <section class="latest-books py-5">
        <div class="container">
            <h2 class="text-center mb-4">최신 도서</h2>
            <div id="latestBooksCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <% 
                    int booksPerSlide = 4;
                    // totalSlides = 5; //책은 20개만 가져오기로함
                    int totalSlides = (int) Math.ceil(recentBooks.size() / (double) booksPerSlide);
                    
                    for(int i = 0; i < totalSlides; i++) {
                        int startIdx = i * booksPerSlide;	// 
                        int endIdx = Math.min(startIdx + booksPerSlide, recentBooks.size());
                    %>
                        <div class="carousel-item <%= i == 0 ? "active" : "" %>">
                            <div class="row justify-content-center">
                                <% for(int j = startIdx; j < endIdx; j++) { 
                                    Book book = recentBooks.get(j);
                                %>
                                    <div class="col-md-3">
                                        <a class="card h-100" href="book/detail.jsp?bno=<%=book.getNo() %>">
                                            <img src="<%= book.getCoverImagePath() %>" class="card-img-top" alt="<%= book.getTitle() %>">
                                            <div class="card-body">
                                                <h5 class="card-title"><%= book.getTitle() %></h5>
                                                <p class="card-text">
                                                    <small class="text-muted">저자: <%= book.getAuthor() %></small>
                                                    <small class="text-muted">출판사: <%= book.getPublisher() %></small>
                                                </p>
                                            </div>
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#latestBooksCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#latestBooksCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>
    </section>
    
    <!-- recommendation Books Carousel Section -->
	<section class="latest-books py-5">
	    <div class="container">
	        <h2 class="text-center mb-4">추천 도서</h2>
	        <div id="recommendBooksCarousel" class="carousel slide" data-bs-ride="carousel">
	            <div class="carousel-inner">
	                <% 
	                int booksPerSlide2 = 4;
	                int totalSlides2 = (int) Math.ceil(recommendBooks.size() / (double) booksPerSlide2);
	
	                for(int i = 0; i < totalSlides2; i++) {
	                    int startIdx = i * booksPerSlide2;
	                    int endIdx = Math.min(startIdx + booksPerSlide2, recommendBooks.size());
	                %>
	                    <div class="carousel-item <%= i == 0 ? "active" : "" %>">
	                        <div class="row justify-content-center">
	                            <% for(int j = startIdx; j < endIdx; j++) { 
	                                Book book = recommendBooks.get(j);
	                            %>
	                                <div class="col-md-3">
	                                    <a class="card h-100" href="book/detail.jsp?bno=<%=book.getNo() %>">
	                                        <img src="<%= book.getCoverImagePath() %>" class="card-img-top" alt="<%= book.getTitle() %>">
	                                        <div class="card-body">
	                                            <h5 class="card-title"><%= book.getTitle() %></h5>
	                                            <p class="card-text">
	                                                <small class="text-muted">저자: <%= book.getAuthor() %></small><br>
	                                                <small class="text-muted">출판사: <%= book.getPublisher() %></small>
	                                            </p>
	                                        </div>
	                                    </a>
	                                </div>
	                            <% } %>
	                        </div>
	                    </div>
	                <% } %>
	            </div>
	            <button class="carousel-control-prev" type="button" data-bs-target="#recommendBooksCarousel" data-bs-slide="prev">
	                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	                <span class="visually-hidden">Previous</span>
	            </button>
	            <button class="carousel-control-next" type="button" data-bs-target="#recommendBooksCarousel" data-bs-slide="next">
	                <span class="carousel-control-next-icon" aria-hidden="true"></span>
	                <span class="visually-hidden">Next</span>
	            </button>
	        </div>
	    </div>
	</section>

    <!-- Donation Books Carousel Section  -->
    <section class="latest-books py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-4">기증 도서</h2>
            <div id="donationBooksCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <% 
                    int booksPerSlide3 = 4;
                    int totalSlides3 = (int) Math.ceil(donationBooks.size() / (double) booksPerSlide3);
                    
                    for(int i = 0; i < totalSlides3; i++) {
                        int startIdx = i * booksPerSlide3;
                        int endIdx = Math.min(startIdx + booksPerSlide3, donationBooks.size());
                    %>
                        <div class="carousel-item <%= i == 0 ? "active" : "" %>">
                            <div class="row justify-content-center">
                                <% for(int j = startIdx; j < endIdx; j++) { 
                                    Donation donation = donationBooks.get(j);
                                %>
                                    <div class="col-md-3">
                                        <a class="card h-100 donation-card" href="donation/donation-board.jsp">
                                            <div class="card-body">
                                                <h5 class="card-title text-center mb-3"><%= donation.getTitle() %></h5>
                                                <div class="book-info">
                                                    <p class="mb-2">
                                                        <i class="fas fa-user-edit me-2"></i>
                                                        <span>저자: <%= donation.getAuthor() %></span>
                                                    </p>
                                                    <p class="mb-2">
                                                        <i class="fas fa-building me-2"></i>
                                                        <span>출판사: <%= donation.getPublisher() %></span>
                                                    </p>
                                                    <p class="mb-2">
                                                        <i class="fas fa-gift me-2"></i>
                                                        <span>기증자: <%= donation.getUser().getId() %></span>
                                                    </p>
                                                    <p class="mb-0">
                                                        <i class="fas fa-book me-2"></i>
                                                        <span><%= libraries.get(donation.getLibrary().getNo()-1).getName() %></span>
                                                    </p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#donationBooksCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#donationBooksCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>
    </section>

    <%@ include file="../common/footer.jsp" %>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
    
    	$("#form-condition").submit(function() {
    		if($("#search-bar").val() == ""){
    			alert("검색어를 입력해주세요.");
    			$("#form-condition").focus();
    			return false;
    		}
    		
    		return true;
    	});
    
    </script>
</body>
</html>