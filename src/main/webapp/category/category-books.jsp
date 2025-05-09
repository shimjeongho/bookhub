<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Set"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="kr.co.bookhub.vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.CategoryBooksMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 맵퍼
	CategoryBooksMapper categoryBooksMapper = MybatisUtils.getMapper(CategoryBooksMapper.class);	

	// 카테고리 번호
	int cateNo = StringUtils.strToInt(request.getParameter("cateNo"));
	int subCateNo = StringUtils.strToInt(request.getParameter("subCateNo"), 0);
	
	// 카테고리 정보 가져오기
	Category category = categoryBooksMapper.getCategory(cateNo);
	
 	// 정렬 조건
 	String sort = StringUtils.nullToStr(request.getParameter("sort"), "newest");

 	// 데이터 정보를 가져오는 기준값 담을 Map 생성
	Map<String, Object> condition = new HashMap<>();
	condition.put("cateNo", cateNo);
	condition.put("subCateNo", subCateNo);
	condition.put("sort", sort != null ? sort : "newest");
 	
 	// 검색어
 	String searchPart = StringUtils.nullToStr(request.getParameter("searchPart"), "title");
 	String searchStr = StringUtils.nullToBlank(request.getParameter("searchStr"));
 	
 	// 불용어 리스트
    Set<String> stopwords = Set.of("은", "는", "이", "가", "을", "를", "의", "에", "도", "다", "로", "에서", "에게", "한", "하다");

    // 키워드 토큰화
    List<String> keywords = Arrays.stream(searchStr.split("\\s+"))   // 한개 이상의 공백 문자 나눈 후 스트림 변환
                   .filter(word -> !word.isBlank())   // ""와 " "와 "\t" 등 빈 문자열 제거
                   .filter(word -> !stopwords.contains(word))	// 불용어 제거
                   .distinct()   // 중복 키워드 제거
                   .collect(Collectors.toList());	// 스트림을 리스트 형태로 수집

	condition.put("searchPart", searchPart);
	condition.put("searchStr", searchStr);
	condition.put("keywords", keywords);
	
	// 조건에 맞는 도서의 총 개수
	int totalRows = categoryBooksMapper.getTotalRows(condition);
	
	// 페이지네이션
	int pageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	Pagination pagination = new Pagination(pageNo, totalRows);
	condition.put("pageNo", pageNo);
	condition.put("offset", pagination.getOffset());
	condition.put("rows", pagination.getRows());
	
	// 서브 카테고리 가져오기
	List<Category> subCategories = categoryBooksMapper.getSubCategory(cateNo);
	
	// 카테고리와 페이지에 해당하는 도서 목록 가져오기
	List<Book> books = categoryBooksMapper.getBooksByCategoryAndKeywords(condition);
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>도서 목록 - 북허브</title>
	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Font Awesome -->
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
	<!-- Custom CSS -->
	<link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
	<%@ include file="../common/nav.jsp" %>
	
	<!-- Search Header -->
    <header class="search-header">
        <div class="container">
			<p class="fs-3"><%=category.getName() %></p>
            
            <form id="category-books-form" class="row justify-content-center"
            	method="get">
            	<input type="hidden" name="cateNo" value="<%=cateNo %>" >
            	<input type="hidden" name="page" value="<%=pageNo %>" >
            	<input type="hidden" name="sort" value="<%=sort %>" >
            	
                <div class="col-md-8">
                	<div class="row mb-3">
                    	<div class="col-md-4">
                        	<select name="subCateNo" id="sub-category" class="form-select">
                                <option value="">전체</option>
                                
<%
	if (!subCategories.isEmpty()) {
		for (Category cate : subCategories) {
%>
                                <option value="<%=cate.getNo() %>" <%=cate.getNo() == subCateNo ? "selected" : "" %>><%=cate.getName() %></option>
<%
		}
	}
%>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row justify-content-center">
						<div class="col-md-4">
							<div class="input-group" style="height: 100%;">
							    <select name="searchPart" class="form-select">
								    <option value="title" <%="title".equals(searchPart) ? "selected" : "" %>>제목</option>
				                    <option value="author" <%="author".equals(searchPart) ? "selected" : "" %>>저자</option>
				                    <option value="publisher" <%="publisher".equals(searchPart) ? "selected" : "" %>>출판사</option>
				                    <option value="isbn" <%="isbn".equals(searchPart) ? "selected" : "" %>>ISBN</option>
								</select>
		                	</div>
						</div>
		                  
						<div class="col-md-8">
		                    <div class="input-group">
                        		<input type="search" name="searchStr" class="form-control form-control-lg" placeholder="검색어를 입력하세요" value="<%=searchStr %>">
		                        <button id="search-btn" class="btn btn-primary" type="button">
		                            <i class="fas fa-search"></i> 검색
		                        </button>
		                    </div>
		                </div>
		            </div>
                </div>
            </form>
        </div>
    </header>

    <!-- Search Results -->
    <main class="container py-4">
        <div class="row">
            <!-- Results -->
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <p class="m-0">
<%
	if (!searchStr.isEmpty()) {
%>
						<%=searchStr %> 검색결과
<%
	}
%>
                    	<strong><%=totalRows %></strong>건
                    </p>
                    
                    <select class="form-select" id="sort-select" style="width: auto;">
<%
	if (!"".equals(searchStr)) {
%>
                        <option value="newest" <%="accuracy".equals(sort) ? "selected" : "" %>>정확도순</option>
<%
	}
%>
                        <option value="newest" <%="newest".equals(sort) ? "selected" : "" %>>최신순</option>
	                    <option value="title" <%="title".equals(sort) ? "selected" : "" %>>제목순</option>
	                    <option value="rating" <%="rating".equals(sort) ? "selected" : "" %>>인기순</option>
                    </select>
                </div>

                <!-- Result Items -->
                <div class="search-results" style="padding: 0;">
<%
	for (Book book : books) {
%>
					<div class="search-result-item bg-white shadow-sm rounded mb-3 transition-all" style="transition: all 0.3s ease;">
                        <div class="row p-3">
                            <a href="/bookhub/book/detail.jsp?bno=<%=book.getNo() %>" class="col-md-2">
                                <img src="<%=book.getCoverImagePath() %>" alt="책 표지" class="img-fluid">
                            </a>
                            <div class="col-md-10">
                                <h5 class="mb-2">
                                    <a href="/bookhub/book/detail.jsp?bno=<%=book.getNo() %>" class="text-decoration-none"><%=book.getTitle() %></a>
                                </h5>
                                <p class="book-meta mb-2">
                                    저자: <%=book.getAuthor() %> | 출판사: <%=book.getPublisher() %> | 발행년도: <%=book.getPubDate() %>
                                </p>
                                <p class="mb-2"><%=book.getDescription() %></p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="/bookhub/book/detail.jsp?bno=<%=book.getNo() %>" class="btn btn-sm btn-outline-primary">예약하기</a>
                                </div>
                            </div>
                        </div>
                    </div>
<%
	}
%>   
                </div>

<%
	if (totalRows > 0) {
%>
				<!-- Pagination -->
                <nav class="mt-4">
                	<ul id="pagination" class="pagination justify-content-center">
<%
		if (!pagination.isFirst()) {
%>
						<li class="page-item">
                            <a href="?page=<%=pagination.getPrevPage() %>" class="page-link"
                               data-page-no="<%=pagination.getPrevPage() %>">이전</a>
                        </li>
<%
		}

		int currentPage = pagination.getCurrentPage();
		int beginPage = pagination.getBeginPage();
		int endPage = pagination.getEndPage();
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
		                	<a href="?page=<%=num %>" class="page-link" 
		                        data-page-no="<%=num %>"><%=num %></a>
						</li>
<%         
			}
		}
		
		if (!pagination.isLast()) {
%>
						<li class="page-item <%=pagination.isLast() ? "disabled" : "" %>">
                            <a href="?page=<%=pagination.getNextPage() %>" class="page-link"
                               data-page-no="<%=pagination.getNextPage() %>">다음</a>
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
        </div>
    </main>
	
	<%@ include file="../common/footer.jsp" %>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	
	<script>
		// category-books 페이지 form
		const $categoryBooksForm = $("#category-books-form");
	
		// 서브 카테고리 선택 이벤트
		$("#sub-category").change(function() {
			$categoryBooksForm.find("input[name=sort]").val("newest"); 	// 정렬 초기화
			$categoryBooksForm.find("input[name=searchStr]").val("");	// 검색어 초기화
			$categoryBooksForm.find("input[name=page]").val(1);			// 페이지 초기화
			$categoryBooksForm.trigger("submit");
		});
	
		// 정렬 선택 이벤트
		$("#sort-select").change(function() {
			$categoryBooksForm.find("input[name=sort]").val($(this).val());
			$categoryBooksForm.find("input[name=page]").val(1);			// 페이지 초기화
			$categoryBooksForm.trigger("submit");
		});
		
		// 페이지네이션
		$("#pagination .page-link").click(function() {
			const page = $(this).data("page-no");
			
			if (!page) return false;
			
			$categoryBooksForm.find("input[name=page]").val(page);
			$categoryBooksForm.trigger("submit");
			
			return false;
		});
		
		// 검색 버튼
		$("#search-btn").click(function() {
			const searchStr = $categoryBooksForm.find("input[name=searchStr]").val().trim();
			
			if (!searchStr) {
				alert("검색어를 입력해 주세요.");
				return false;
			}
			
			$categoryBooksForm.find("input[name=sort]").val("accuracy"); // 검색 시 정확도순으로 정렬
			$categoryBooksForm.find("input[name=page]").val(1);			// 페이지 초기화
			$categoryBooksForm.trigger("submit");
			
			return false;
		});
		
		// 검색 인풋 엔터키
		$("input[name=searchStr]").keydown(function(e) {
			if (e.keyCode == 13) { // enter 키 
				if (!$(this).val().trim()) {
					alert("검색어를 입력해 주세요.");
					return false;
					
				} else {
					$categoryBooksForm.find("input[name=sort]").val("accuracy"); // 검색 시 정확도순으로 정렬
					$categoryBooksForm.find("input[name=page]").val(1);	// 페이지 초기화
					$categoryBooksForm.trigger("submit");
				}
			}
		});
		
	</script>
</body>
</html>