<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="kr.co.bookhub.util.SearchAiUtils"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.SearchMapper"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*	
		검색
		요청 정보
			- 요청 URL
				search
			- 요청 파라미터
				name		value
				------------------
				search		검색어
		
		로그인 처리 절차
		1. 요청 파라미터 값으로 검색어를 조회한다.
		2. condition map에 상태 값들을 넣는다.(키워드 리스트, 검색조건(제목,저자,출판사))
		3. 메퍼로 보낸다.
	*/
	// 파라미터값 받아오기
	String category = StringUtils.nullToStr(request.getParameter("category"), "title");
	String searchContent = StringUtils.nullToStr(request.getParameter("search"), "");
	int pageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	String sort = StringUtils.nullToStr(request.getParameter("sort"), "accuracy");
	String ai = StringUtils.nullToStr(request.getParameter("ai"), "N");
	boolean isSearchContent = false;
	
	// searchContent는 화면에 나올 데이터, search는 검색 로직에 사용될 데이터
	String search = searchContent;
	
	// 상태를 나타내는 맵 선언(searchMapper에서 쓰임)
	Map<String, Object> condition = new HashMap<>();
	
	// ai 검색을 사용할 때(ai==O), ai==x면 패스됨
	if ("O".equals(ai)){
		String aiSearch = SearchAiUtils.aiSearch(search);
		search = aiSearch;
		System.out.println("ai 검색어: " + aiSearch);
	}
	
	
	// 불용어 리스트
	Set<String> stopwords = Set.of("은", "는", "이", "가", "을", "를", "의", "에", "도", "다", "로", "에서", "에게", "한", "하다");

	// 키워드 토큰화
	List<String> keywords = Arrays.stream(search.split("\\s+"))	// 한개 이상의 공백 문자 나눈 후 스트림 변환
		            .filter(word -> !word.isBlank())	// ""와 " "와 "\t" 등 빈 문자열 제거
		            .filter(word -> !stopwords.contains(word))	// 불용어 제거
		            .distinct()	// 중복 키워드 제거
		            .collect(Collectors.toList());	// 스트림을 리스트 형태로 수집
	
	condition.put("search", search);
	condition.put("keywords", keywords);
	condition.put("category", category);
	condition.put("sort", sort);
	condition.put("page", pageNo);
	
	// 구현객체 획득하기
	SearchMapper searchMapper = MybatisUtils.getMapper(SearchMapper.class);
	
	// 목록 조회(만약 검색이 ""라면 books는 비어있는걸로 리턴)
	List<Book> books;
	
	// 페이지네이션
	int totalRows = 0;
	if (search == null || search.trim().isEmpty()) {
		totalRows = 0;
	} else {
		totalRows = searchMapper.getTotalRows(condition);
	}
	
	Pagination pagination = new Pagination(pageNo, totalRows, 10);
	condition.put("offset", pagination.getOffset());
	condition.put("rows", 10);
	
	if (search == null || search.trim().isEmpty()){
		books = new ArrayList<>();
	} else {
		books = searchMapper.searchBooks(condition);
	}
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검색 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
    <!-- Navigation -->
    <%@ include file="../common/nav.jsp" %> 

    <form id="form-condition"
		method="get"
		action="search.jsp">
	
    <input type="hidden" name="page" value="1" />
     
    <!-- Search Header -->
    <header class="search-header">
        <div class="container">
<%
	if (!"".equals(searchContent)) { 
%>
        	<p class="fs-3"><%=searchContent %> 검색결과 <strong><%=totalRows %></strong>개</p>
<%
	}
%>
        	<div class="row justify-content-center">
	        	<div class="col-md-2">
				  <div class="d-flex">
				    <div class="form-check me-3">
				      <input class="form-check-input" type="radio" name="ai" id="standard-search" value="N" <%="N".equals(ai) ? "checked" : "" %>>
				      <label class="form-check-label" for="standard-search">일반</label>
				    </div>
				    <div class="form-check">
				      <input class="form-check-input" type="radio" name="ai" id="ai-search" value="O" <%="O".equals(ai) ? "checked" : "" %>>
				      <label class="form-check-label" for="ai-search">AI</label>
				    </div>
				  </div>
				</div>
			
                <div class="col-md-2">
                    <div class="input-group" style="height: 100%;">
                    	<select class="form-select" name="category">
							<option value="title" <%="title".equals(category) ? "selected" : "" %>>제목</option>
							<option value="author" <%="author".equals(category) ? "selected" : "" %>>저자</option>
							<option value="publisher" <%="publisher".equals(category) ? "selected" : "" %>>출판사</option>
							<option value="isbn" <%="isbn".equals(category) ? "selected" : "" %>>ISBN</option>
						</select>
                    </div>
	            </div>
						
                <div class="col-md-5">
                    <div class="input-group">
                        <input type="search" 
                        	id="search-bar"
                        	class="form-control" 
                        	value="<%=searchContent %>"
                        	placeholder="검색어를 입력하세요"
                        	name="search"
                        	maxlength="100">
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-search"></i> 검색
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Search Results -->
    <main class="container py-4">
        <div class="row justify-content-center">
            <!-- Results -->
            <div class="col-md-9">
                <div class="d-flex justify-content-between align-items-center mb-4">
<%
	if (!"".equals(searchContent)) { 
%>
                    <p class="m-0">"<%=search %>" 검색결과 <strong><%=books.size() %></strong>건</p>
<%
	}
%>
                    <select class="form-select" name="sort" style="width: auto;">
                        <option value="accuracy" <%="accuracy".equals(sort) ? "selected" : "" %>>정확도</option>
                        <option value="newest" <%="newest".equals(sort) ? "selected" : "" %>>최신순</option>
                        <option value="alphabetical" <%="alphabetical".equals(sort) ? "selected" : "" %>>제목순</option>
                        <option value="popular" <%="popular".equals(sort) ? "selected" : "" %>>인기순</option>
                    </select>
                </div>

                <!-- Result Items -->
<% 
	if (!(books.size() <= 0 || books == null || books.isEmpty()) || totalRows == 0) { 
		if (!"".equals(searchContent)) { 
%>
	<div class="search-result-item bg-white shadow-sm rounded mb-3 p-4 text-center">
    <h5 class="text-muted">책이 존재하지 않습니다.</h5>
	</div>
<% 
		}
	} else {
	for(Book book : books) { 
	// *** 나중에 jquery이용해서 조건 바뀔때 마다 검색결과 몇건 나왔는지 수정하기 *** %>
                <div class="search-results" style="padding: 0;">
                    <div class="search-result-item bg-white shadow-sm rounded mb-3 transition-all" style="transition: all 0.3s ease;">
                        <div onclick="location.href ='../book/detail.jsp?bno=<%=book.getNo() %>'" class="row p-3">
                            <div class="col-md-2">
                                <img src="<%=book.getCoverImagePath() %>" alt="<%=book.getTitle() %>" class="img-fluid">
                            </div>
                            <div class="col-md-10">
                                <h5 class="mb-2">
                                    <a href="../book/detail.jsp?bno=<%=book.getNo() %>" class="text-decoration-none"><%=book.getTitle() %></a>
                                </h5>
                                <p class="book-meta mb-2">
                                    저자: <%=book.getAuthor() %> | 출판사: <%=book.getPublisher() %> | 발행년도: <%=book.getPubDate() %>
                                </p>
                                <p class="mb-2"><%=book.getDescription() %></p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <button class="btn btn-sm btn-outline-primary">예약하기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
<% 
	}
} 
%>

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
                            <a class="page-link" href="search.jsp?page=<%=prevPage %>" data-page-no="<%=prevPage %>">이전</a>
                        </li>
<%
	}
%>
<%
	for (int num = beginPage; num <= endPage; num++) {
%>
                        <li class="page-item <%=pageNo == num ? "active" : "" %>">
                        <a class="page-link" href="search.jsp?page=<%=num %>" data-page-no="<%=num %>"><%=num %></a>
                        </li>
<%
	}

		if (!pagination.isLast()) {
%>
                        <li class="page-item <%=pagination.isLast() ? "disabled" : "" %>">
                            <a class="page-link" href="search.jsp?page=<%=nextPage %>" data-page-no="<%=nextPage %>">다음</a>
                        </li>
                    </ul>
                </nav>
<%
		}
	}
%>
            </div>
        </div>
    </main>
    </form>
    
    <!-- Footer -->
    <%@ include file="../common/footer.jsp" %> 

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
    
    	$("#form-condition").submit(function() {
    		if($("#search-bar").val() == ""){
    			alert("검색어를 입력하시오.");
    			$("#form-condition").focus();
    			return false;
    		}
    		
    		return true;
    	});
    
	 	// select박스에서 change이벤트가 발생될 때
		// 실행될 이벤트 핸들러 등록하기
		$("select[name='sort']").change(function() { 
			$("#form-condition").trigger("submit");
		});
    	
    
    	// pagenation의 링크에서 click이벤트가 발생될 때
    	// 실행될 이벤트 핸들러 등록하기
    	$("#pagenation-search .page-link").click(function() {
    		// 클릭한 링크의 data-page-no="x" 속성값을 읽어온다.
    		let pageNo = $(this).attr("data-page-no");
    		// 컨디션 조건의 히든필드(name="page"인 히든필드)에 페이지 번호를 설정한다. 
    		$("#form-condition input[name=page]").val(pageNo);
    		
    		// 컨디션 조건이 있는 form을 서버로 제출한다.
    		$("#form-condition").trigger("submit");
    		return false;
    	});
    
    </script>
    <!-- Hover Animation Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const resultItems = document.querySelectorAll('.search-result-item');
            
            resultItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    this.classList.add('shadow', 'border', 'border-primary');
                    this.style.transform = 'translateY(-3px)';
                });
                
                item.addEventListener('mouseleave', function() {
                    this.classList.remove('shadow', 'border', 'border-primary');
                    this.style.transform = 'translateY(0)';
                });
            });
        });
    </script>
</body>
</html> 