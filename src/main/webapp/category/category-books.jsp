<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@page import="kr.co.bookhub.vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.CategoryBooksMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 카테고리 번호
	int categoryNo = StringUtils.strToInt(request.getParameter("cateNo"));
	String subCateNoParam = request.getParameter("subCateNo");
	int subCategoryNo = (!subCateNoParam.isEmpty() && subCateNoParam != null)
			? StringUtils.strToInt(subCateNoParam) : 0;

	// 카테고리 맵퍼
	CategoryBooksMapper categoryBooksMapper = MybatisUtils.getMapper(CategoryBooksMapper.class);
	
	// 서브 카테고리 가져오기
	List<Category> subCategories = categoryBooksMapper.getSubCategory(categoryNo);
	
	// 카테고리와 페이지에 해당하는 도서 목록 가져오기
	List<Book> books = categoryBooksMapper.getBooksByCategory(categoryNo, subCategoryNo);
	
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
            <form class="row justify-content-center">
                <div class="col-md-8">
                    <div class="row g-2 mb-3">
                        <div class="col-md-4">
                            <select class="form-select" id="sub-category">
                                <option value="">전체</option>
                                
<%
	if (!subCategories.isEmpty()) {
		for (Category cate : subCategories) {
%>
                                <option value="<%=cate.getNo() %>"><%=cate.getName() %></option>
<%
		}
	}
%>
                            </select>
                        </div>
                    </div>
                    <div class="input-group">
                        <input type="search" class="form-control form-control-lg" placeholder="검색어를 입력하세요">
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-search"></i> 검색
                        </button>
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
                    <p class="m-0">"파이썬" 검색결과 <strong>127</strong>건</p>
                    <select class="form-select" style="width: auto;">
                        <option>최신순</option>
                        <option>제목순</option>
                        <option>인기순</option>
                    </select>
                </div>

                <!-- Result Items -->
                <div class="search-results" style="padding: 0;">
                    <div class="search-result-item bg-white shadow-sm rounded mb-3 transition-all" style="transition: all 0.3s ease;">
                        <div class="row p-3">
                            <div class="col-md-2">
                                <img src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=160&q=80" alt="책 표지" class="img-fluid">
                            </div>
                            <div class="col-md-10">
                                <h5 class="mb-2">
                                    <a href="#" class="text-decoration-none">파이썬 프로그래밍 입문</a>
                                </h5>
                                <p class="book-meta mb-2">
                                    저자: 김철수 | 출판사: 코딩출판사 | 발행년도: 2024
                                </p>
                                <p class="mb-2">파이썬 프로그래밍의 기초부터 실전까지 다루는 입문서입니다.</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <button class="btn btn-sm btn-outline-primary">예약하기</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="search-result-item bg-white shadow-sm rounded mb-3 transition-all" style="transition: all 0.3s ease;">
                        <div class="row p-3">
                            <div class="col-md-2">
                                <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=160&q=80" alt="책 표지" class="img-fluid">
                            </div>
                            <div class="col-md-10">
                                <h5 class="mb-2">
                                    <a href="#" class="text-decoration-none">실전 파이썬 머신러닝</a>
                                </h5>
                                <p class="book-meta mb-2">
                                    저자: 이영희 | 출판사: AI출판사 | 발행년도: 2023
                                </p>
                                <p class="mb-2">파이썬을 활용한 머신러닝 프로젝트 실습 가이드북입니다.</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <button class="btn btn-sm btn-outline-secondary">예약불가</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="search-result-item bg-white shadow-sm rounded mb-3 transition-all" style="transition: all 0.3s ease;">
                        <div class="row p-3">
                            <div class="col-md-2">
                                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=160&q=80" alt="책 표지" class="img-fluid">
                            </div>
                            <div class="col-md-10">
                                <h5 class="mb-2">
                                    <a href="#" class="text-decoration-none">파이썬 데이터 분석</a>
                                </h5>
                                <p class="book-meta mb-2">
                                    저자: 박지민 | 출판사: 데이터출판사 | 발행년도: 2023
                                </p>
                                <p class="mb-2">파이썬을 이용한 데이터 분석의 기초와 응용을 다룹니다.</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <button class="btn btn-sm btn-outline-primary">예약하기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">이전</a>
                        </li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">다음</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </main>
	
	<%@ include file="../common/footer.jsp" %>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	
	<script>
	
	</script>
</body>
</html>