<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.DonationMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		donation form
		- 요청 URL
			donation-form.jsp
			donation-form.jsp.fail=xxx
		- 요청 파라미터
			
	*/
	
	String loginedUserId = "zxcv@zxcv";

	// DonationMapper 구현객체 획득
	DonationMapper donationMapper = MybatisUtils.getMapper(DonationMapper.class);
	
	// 도서관 리스트 조회
	List<Library> libraries = donationMapper.getAllLibrary();
	
	
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 기증 폼 - 북허브</title>
    <!-- Google Fonts - Noto Sans KR -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
	
	<!-- Navigation -->
    <%@ include file="../common/nav.jsp" %>

    <!-- Form Content -->
    <div class="post-form-container">
        <div class="post-form-header">
            <h2>도서 기증 폼</h2>
        </div>
        
        <form id="form-donation" method="post" action="donation.jsp">
            <div class="mb-4">
                <label for="library-select" class="form-label required">도서관 선택</label>
                <select class="form-select" name="library" id="library-select" required>
                    <option value="">도서관을 선택하세요</option>
<%
	for (Library library : libraries) {
%>
                    <option value="<%=library.getNo() %>"><%=library.getName() %></option>
<%
	}
%>
                </select>
            </div>
            
            <div class="mb-4">
                <label for="book-title" class="form-label required">도서 제목</label>
                <input type="text" class="form-control" name="title" id="book-title" placeholder="도서 제목을 입력하세요" required>
            </div>
            
            <div class="mb-4">
                <label for="book-author" class="form-label required">도서 저자</label>
                <input type="text" class="form-control" name="author" id="book-author" placeholder="저자를 입력하세요" required>
            </div>

            <div class="mb-4">
                <label for="book-publisher" class="form-label required">도서 출판사</label>
                <input type="text" class="form-control" name="publisher" id="book-publisher" placeholder="출판사를 입력하세요" required>
            </div>

            <div class="mb-4">
                <label for="book-description" class="form-label required">도서 요약 설명</label>
                <textarea name="description" id="book-description" class="form-control" rows="5" placeholder="도서 내용을 간단히 입력하세요" required></textarea>
                <small id="description-count" class="form-text text-muted">0 / 200자</small>
            </div>
            
            <div class="btn-container">
                <button type="submit" class="btn btn-primary btn-submit">기증 등록</button>
                <button type="button" class="btn btn-secondary btn-cancel" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>
    
    <!-- Footer -->
    <%@ include file="../common/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
	    const form = document.getElementById('form-donation');
	    const librarySelect = document.getElementById('library-select');
	    const titleInput = document.getElementById('book-title');
	    const authorInput = document.getElementById('book-author');
	    const publisherInput = document.getElementById('book-publisher');
	    const descriptionInput = document.getElementById('book-description');
	    const descriptionCount = document.getElementById('description-count');

	    descriptionInput.addEventListener('input', function () {
	        if (this.value.length > 200) {
	            this.value = this.value.slice(0, 200);
	        }
	        descriptionCount.textContent = this.value.length + " / 200자";
	    });
	
	    // 폼 제출 시 유효성 검사
	    form.addEventListener('submit', function (e) {
	        const library = librarySelect.value;
	        const title = titleInput.value.trim();
	        const author = authorInput.value.trim();
	        const publisher = publisherInput.value.trim();
	        const description = descriptionInput.value.trim();
	
	        if (!library || !title || !author || !publisher || !description) {
	            alert('모든 항목을 입력해주세요.');
	            e.preventDefault();
	            return;
	        }
	
	        if (description.length > 100) {
	            alert('도서 요약 설명은 100자 이내로 입력해주세요.');
	            e.preventDefault();
	            return;
	        }
	    });
	    
	</script>
</body>
</html>
