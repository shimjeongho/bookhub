<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = (String)session.getAttribute("LOGINED_USER_ID");
	PostMapper postMapper = MybatisUtils.getMapper(PostMapper.class);
	
	// DB에 저장된 도서관 정보를 가져온다.
	List<Library> libraries = postMapper.getLibraries();
	
	String postCateNo = request.getParameter("postCateNo");
%>    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성 - 북허브</title>
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
    <!-- Navigation -->
	 <%@ include file="../common/nav.jsp"  %> 

    <!-- Form Content -->
    <div class="post-form-container">
        <div class="post-form-header">
            <h2>도서관 문의 게시글 작성</h2>
        </div>
        
        <form id="post-form" 
        	  method="post"
        	  action="lib-post-add.jsp?postCateNo=<%=postCateNo %>">
            <div class="mb-4">
                <label for="librarySelect" class="form-label required">문의 도서관</label>
                <select class="form-select"
                	     name="librarySelect" 
                         id="library-select" required>
                    <option value="">도서관을 선택하세요</option>
<%
	for(Library lib : libraries) {
%>
					 <option value="<%=lib.getNo() %>"
					 		 data-no="<%=lib.getNo() %>"
					 		 data-name="<%=lib.getName() %>"
					 		 data-location ="<%=lib.getLocation()  %>"
					 		 data-img-path="<%=lib.getImgPath() %>"
					 		 data-tel="<%=lib.getTel() %>"
					 		 data-busniess-hours="<%=lib.getBusinessHours() %>"
					 ><%= lib.getName() %></option>
<%
	}
%>					 					 
                </select>
            </div>
			<div class="mb-4 d-none" id="selected-lib-container">
				<input type="hidden" name="libNo" id="inquiry-lib">
				<label for="title" class="form-label required">문의 도서관</label>
				<div id="selected-lib">
					<!-- 문의 도서관란이 나옴. -->
				</div>
			</div>            
            
            <div class="mb-4">
                <label for="postTitle" class="form-label required">게시글 제목</label>
                <input type="text"
                	   name="title" 
                       class="form-control" 
                       id="post-title" 
                       placeholder="게시글 제목을 입력하세요" 
                       required>
            </div>
            
            <div class="mb-4">
                <label for="content" class="form-label required">내용</label>
                <textarea id="post-content" 
                          name="content"
                          class="form-control"></textarea>
            </div>


            <div class="mb-4">
                <label class="form-label">공개 설정</label>
                <div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="isPublic" id="public-post" value="Y" checked>
                        <label class="form-check-label" for="publicPost">
                            공개
                        </label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="isPublic" id="private-post" value="N">
                        <label class="form-check-label" for="privatePost">
                            비공개
                        </label>
                    </div>
                </div>
            </div>
            
            <div class="btn-container">
                <button type="submit" class="btn btn-primary btn-submit">등록</button>
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
            
            $("#library-select").change(function() {
				const $selectedOption = $(this).find("option:selected");
			 	const no = $selectedOption.attr("data-no");
			 	const name =$selectedOption.attr("data-name");
			 	const imgPath = $selectedOption.attr("data-img-path");
			 	const loation = $selectedOption.attr("data-location");
			 	const tel = $selectedOption.attr("data-tel"); 
			 	const businessHours = $selectedOption.attr("data-busniess-hours");
			 	
			 	let $div = $("#selected-lib").empty();
			 	$("input[name='libNo']").val(no);
			 	let content = `
            		<div class="row">
        			<div class="col-2">
                		<img style="max-width:100%;" src="\${imgPath}" alt="도서관 표지"/>
        			</div>
        			<div class="col-10">
                		<p>\${name}</p>                			
                		<p>\${loation}</p>
                		<p>\${tel}</p>                			
                		<p>\${businessHours}</p>                			
        			</div>
        		</div>			 		
			 	`; 
			 	$div.append(content);
			 	$("#selected-lib-container").removeClass("d-none");
			});
            
            /* 해당 입력폼을 서버에 보낼 때 */ 
            $('#post-form').on('submit', function() {
               const inquiryLib = $('#inquiry-lib').val();
               const postTitle = $("#post-title").val();
               const postContent = $('#post-content').summernote('code');
               const postContent2 = $("#post-content").val();
               const isPublic = $('input[name="isPublic"]:checked').val();
               
                if (!inquiryLib || inquiryLib.trim() === "") {
                   alert('문의 도서관을 선택해주세요.');
                   return false;
               }

               if (!postTitle.trim() || !postTitle.trim() === "") {
               	alert('게시글 제목을 입력해주세요.'); 
					return false;
               }
               
               if (!postContent2.trim() || !postContent2.trim() === "") {
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