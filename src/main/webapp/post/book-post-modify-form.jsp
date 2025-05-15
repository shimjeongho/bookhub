<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	PostMapper selectPost = MybatisUtils.getMapper(PostMapper.class);
	Post post = selectPost.selectPostBypostNo(postNo);
	
	String userId = (String)session.getAttribute("LOGINED_USER_ID"); 
	PostMapper postMapper = MybatisUtils.getMapper(PostMapper.class);
	List<Book>books = postMapper.userLoanBookSearch(userId);
%>    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정 - 북허브</title>
    <!-- Google Fonts - Noto Sans KR -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Summernote CSS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Form Content -->
    <div class="post-form-container">
        <div class="post-form-header">
            <h2>도서 문의 게시글 수정</h2>
        </div>
        
        <form id="post-form" method="post" action="book-post-modify.jsp?postCateNo=<%= postCateNo %>&postNo=<%= postNo %>">
        <div id="loan-or-search-book">
        	<!-- 나의 대여 도서 조회, 도서 검색 라디오 버튼으로 선택하기 -->
			<div class="mb-4">
				<div class="form-check form-check-inline mb-3">
					<input class="form-check-input" type="radio"
						name="bookSelectionType" id="borrowedBooks" value="borrowed"checked> 
						<label class="form-check-label" for="borrowedBooks">나의 대여 도서 조회</label>
				</div>
				
				<div class="form-check form-check-inline mb-3">
					<input class="form-check-input" type="radio" name="bookSelectionType" id="book-search"> 
						<label class="form-check-label" for="book-search">도서 검색</label>
				</div>
				
			</div>
			
  			<!-- 나의 대여 도서를 선택했을 경우 나오는 화면 -->
			<div class="mb-4" id="borrowed-books-section">
				<label for="borrowedBookSelect" class="form-label required">대여중인 도서</label> 
				<select class="form-select" id="borrowed-book-select"name="borrowedBookSelect" >
					<option value="">대여 중인 도서를 선택하세요</option>
<%
	for (Book book : books) {
%>
					<option value="<%=book.getNo()%>" 
					    data-no="<%=book.getNo()%>"
						data-title="<%=book.getTitle()%>"
						data-cover-image-path="<%=book.getCoverImagePath()%>"
						data-author="<%=book.getAuthor()%>"
						data-pub-date="<%=book.getPubDate()%>"><%=book.getTitle()%></option>
<%
	}
%>
				</select>
			</div>

			<!-- 도서 검색으로 선택했을 경우, 나오는 화면 -->
			<div class="mb-4 d-none" id="book-search-section">
				<label for="bookSearch" class="form-label required">도서 검색</label>
				<div class="input-group">
					<input type="text" class="form-control" id="input-title"
						placeholder="도서명을 입력하세요">
					<button class="btn btn-outline-secondary" type="button"
						id="search-button">
						<i class="fas fa-search"></i> 검색
					</button>
				</div>
				<!--         <div class="mt-2" id="searchResults">
                    검색 결과가 여기에 표시됩니다
                </div>  -->
			</div>

			<!-- 도서 검색했을 때 나오는 모달창-->
			<div class="modal fade" id="bookSelectionModal" tabindex="-1"
				aria-labelledby="bookSelectionModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-lg">
					<div class="modal-content">

						<div class="modal-header">
							<h5 class="modal-title" id="bookSelectionModalLabel">도서 선택</h5>
							<!-- 해당 버튼은 창 닫기(X) 버튼임. -->
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>

						<div class="modal-body">
							<div class="mb-3">
								<div class="input-group">
									<!-- 도서명을 입력할 수 있는 입력 필드임. id = modalBookSearch -->
									<input type="text" class="form-control" id="modalBookSearch"
										placeholder="도서명을 입력하세요">
									<!-- 검색 버튼  id = modalSearchButton -->
									<button class="btn btn-primary" type="button"
										id="modalSearchButton">
										<i class="fas fa-search"></i> 검색
									</button>
								</div>
							</div>
							<div class="table-responsive">
								<!-- 검색버튼을 누르면 아래 목록들이 나옴. -->
								<table class="table table-hover">
									<thead>
										<tr>
											<!-- 머리 부분-->
											<th scope="col">선택</th>
											<th scope="col">도서명</th>
											<th scope="col">저자</th>
											<!--   <th scope="col">출판사</th>
                                            <th scope="col">출판년</th> -->
										</tr>
									</thead>
									<tbody id="modal-search-results">
										<!-- 검색 결과가 여기에 표시됩니다 -->
									</tbody>
								</table>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">취소</button>
							<button type="button" class="btn btn-primary"
								id="selectBookButton">선택</button>
						</div>
					</div>
				</div>
			</div>
		</div>
  			<!-- 문의 도서란 -->
            <div class="mb-4" id="selected-book-container">
            	<input type="hidden" name="bookNo" id="inquiry-book" value="<%= post.getBook().getNo() %>" />
                <label for="title" class="form-label required">문의 도서</label>
                <div id="selected-book">
                	<div class="row">
            	    	<div class="col-2">
	                		<img style="max-width: 100%;" src="<%= post.getBook().getCoverImagePath() %>" alt="도서 표지"/>
            			</div>
            			
            			<div class="col-10">
	                		<p><%= post.getBook().getTitle() %></p>                			
	                		<p><%= post.getBook().getAuthor() %></p>
	                		<p><%= post.getBook().getPubDate() %></p>                			
            			</div>
            		</div>
            		<button type="button" class="btn btn-outline-primary me-2" id="change-book-btn">도서 변경</button>
                </div>
                
            </div>
            
            <div class="mb-4">
                <label for="postTitle" class="form-label required">게시글 제목</label>
                <input type="text" class="form-control" id="post-title" name="postTitle" value="<%= post.getTitle() %>" required>
            </div>
            
            <div class="mb-4">
                <label for="content" class="form-label required">내용</label>
                <textarea id="post-content" class="form-control" name="postContent"><%= post.getContent() %></textarea>
            </div>
           
            <div class="mb-4">
                <label class="form-label">공개 설정</label>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="isPublic" id="public-post" value="Y" 
                    <%= "Y".equals(post.getIsPublic()) ?  "checked" : "" %>>
                    <label class="form-check-label" for="publicPost">공개</label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="isPublic" id="private-post" value="N"
                    <%= "N".equals(post.getIsPublic()) ?  "checked" : "" %>>
                    <label class="form-check-label" for="privatePost">
                        비공개
                    </label>
                </div>
            </div>
            
            <div class="btn-container">
                <button type="submit" class="btn btn-primary btn-submit">수정</button>
                <button type="button" class="btn btn-secondary btn-cancel" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <%@ include file="../common/footer.jsp"%> 

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Summernote JS -->
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
    
    <script>
		

        $(document).ready(function() {
		    //도서 변경 버튼 눌렀을 때, 선택된 도서를 지우고, 문의 도서란을 화면에 안 보이게 한다.
		    $("#change-book-btn").click(function () {
				$("#selected-book").empty(); 
				$("#selected-book-container").addClass("d-none");
				$("#loan-or-search-book").removeClass("d-none").show();
		    });	
				
            // 도서 선택 모달 관련 스크립트
            const bookSelectionModal = new bootstrap.Modal(document.getElementById('bookSelectionModal'));
            const $selectBookButton = $('#selectBookButton');
            const modalSearchButton = document.getElementById('modalSearchButton');
            const modalBookSearch = document.getElementById('modalBookSearch');
            const modalSearchResults = document.getElementById('modal-search-results');
            
            // 도서 검색에서 사용할 ajax를 별도로 정의함.
            function searchBooks(title) {
                $.ajax ({
	                   	type : "get",  
	                   	url : "book-search.jsp", 
	                   	data : {title : title} , 
	                   	dataType : "json",  // get 방식으로 book-search.jsp에 요청을 하고 title 값을 같이 보내서 보냄.
	                   	success : function(bookList) { // 요청에 성공하면, 아래 함수가 동작됨.
	                   		let $div = $("#modal-search-results").empty();// 모달창 안에, 도서 검색결과가 나오는 tbody 안에를 삭제함.
	                   		
	                   		for(let book of bookList) { 
			                   		let content = `
			                        <tr>
			                            <td> 
			                            	<input type="radio" name="bookSelection" class="bookSelection" value="3"
			                            		data-no="\${book.no}"
			                            		data-title="\${book.title}"
			                            		data-cover-image-path="\${book.coverImagePath}"
			                            		data-author="\${book.author}"
			                            		data-publisher="\${book.publisher}"
			                            		data-pub-date="\${book.pubDate}">
			                            </td>
			                            <td>"\${book.title}"</td>
			                            <td> "\${book.author}"</td> 
			                        </tr>
			                    `; 
			                    $div.append(content)// 모달창 안에, 도서 검색결과가 나오는 tbody 안에를 content로 추가한다. 
	                   		}
	                   	}
                  }) //ajax 종료
      	} // end function searchBooks   
            
            //처음에는 나의 대여 도서 조회 및 도서검색 라디오 버튼이 화면에 나오지 않도록 설정.
        	$("#loan-or-search-book").addClass("d-none");
        	
            // Initialize Summernote
            $('#post-content').summernote({
                height: 400,
                minHeight: 300,
                lang: 'ko-KR',
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ]
            });
            
            
            // 나의 대여 도서 및 도서 검색 라디오 버튼을 눌렀을 때
            $('input[name="bookSelectionType"]').change(function() { 
            	$("#selected-book").empty(); 
            	$("#selected-book-container").addClass("d-none");
                if ($(this).val() === 'borrowed') { 
                    $('#borrowed-books-section').removeClass('d-none');
                    $('#book-search-section').addClass('d-none'); 
                    $('#borrowed-book-select').prop('required', true);
                    $('#book-search').prop('required', false); 
                } else { //"도서 검색일 경우"
                    $('#borrowed-books-section').addClass('d-none');
                    $('#book-search-section').removeClass('d-none');
                    $('#borrowed-book-select').prop('required', false);
                    $('#book-search').prop('required', true);
                }
            });
            
            //나의 대여 도서 중 하나를 선택했을 경우
            $('#borrowed-book-select').change(function() { 
            	// option 태그 중에서 selected한 태그를 $selectedOption에 할당.
                const $selectedOption = $(this).find('option:selected'); 
            	
            	//selected된 option 태그에 값이 존재한다면 data 속성의 값을 추출하고, 문의 도서란에 데이터 뿌리기.
                if($selectedOption.val()) {
                	const no = $selectedOption.data("no");
                	const title =$selectedOption.data("title");
                	const coverImagePath = $selectedOption.data("cover-image-path");
                	const author = $selectedOption.data("author");
                	const pubDate = $selectedOption.data("pub-date"); 
                	let $div = $("#selected-book").empty(); 
                	$("#inquiry-book").val(no); 
                	let content = `
                		<div class="row">
	            			<div class="col-2">
		                		<img style="max-with: 100%;" src="\${coverImagePath}" alt="도서 표지"/>
	            			</div>
	            			<div class="col-10">
		                		<p>"\${title}"</p>                			
		                		<p>"\${author}"</p>
		                		<p>"\${pubDate}"</p>                			
	            			</div>
	            		</div>
                	`; 
                	$div.append(content);
                	$("#selected-book-container").removeClass("d-none");
                }
            });
            
            // 도서 검색에서 검색 버튼을 눌럿을 때
            $('#search-button').click(function() {
            	//$("#selectBookButton").addClass("disabled");
                const searchBookTitle = $('#input-title').val().trim();
                if (searchBookTitle) {
                	searchBooks(searchBookTitle); 
                    bookSelectionModal.show(); 
                    $('#modalBookSearch').val(searchBookTitle);
                }
            });
            
            // 모달창 내에 검색 버튼을 눌렀을 때
            modalSearchButton.addEventListener('click', function() {
                const searchTerm = modalBookSearch.value.trim();
                searchBooks(searchTerm);
            });
            
            //모달창 안에서 선택 버튼을 눌렀을 때
            $selectBookButton.click(function() {
            	//bookSelection 태그에서 checked된 태그를 $ selectedBook에 할당
                const $selectedBook = $('input[name="bookSelection"]:checked');
            	
            	//checked한 태그에 값이 있을 경우, 아래 속성값을 뽑는다.
                if ($selectedBook.val()) { 
                	const no = $selectedBook.data("no"); // 
                	const title = $selectedBook.data("title");
                	const coverImagePath = $selectedBook.data("cover-image-path");
                	const author = $selectedBook.data("author");
                	const pubDate = $selectedBook.data("pub-date");
                	
                	//뽑은 속성값 중 no를 inquiry-book 태그의 value값으로 설정한다.
                	$("#inquiry-book").val(no);
                	
                	$("#selected-book").empty();
                	
                	let content = ` 
                		<div class="row">
                			<div class="col-2">
		                		<img style="max-width:100%;" src="\${coverImagePath}" alt="도서 표지"/>
                			</div>
                			<div class="col-10">
		                		<p>"\${title}"</p>                			
		                		<p>"\${author}"</p>
		                		<p>"\${pubDate}"</p>                			
                			</div>
                		</div>
                	` ; 
                	$("#selected-book").append(content);
                    bookSelectionModal.hide();
	                $("#selected-book-container").removeClass("d-none");
                } else {
                	alert("문의할 도서를 선택하세요");
                }
            });
            
            // 폼 제출할 때
            $("#post-form").on('submit',function () {
                const inquiryBook = $('#inquiry-book').val();
                const postTitle = $('#post-title').val();
                const postContent = $('#post-content').summernote('code');
                const isPublic = $('input[name="isPublic"]:checked').val();
                
                if (!inquiryBook || inquiryBook.trim() === "") {
                    alert('문의 도서를 선택해주세요.');
                    return false;
                } 
 
                if (!postTitle.trim()) {
                    alert('게시글 제목을 입력해주세요.'); 
                    return false;
                }
                
                if (!postContent.trim() || postContent.trim() === "") {
                    alert('내용을 입력해주세요.');
                    return false;
                }
                // 임시로 성공 메시지 표시
                alert('게시글이 등록되었습니다.');
                // 목록 페이지로 이동
                return true;
            });
            
        });
    </script>
</body>
</html> 