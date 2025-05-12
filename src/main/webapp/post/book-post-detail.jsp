<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 도서 문의 게시판의 게시글의 상세페이지. 
     게시글의 제목을 클릭하면 넘어오는 페이지 
     postCateNo(해당 문의 유형에 대한 고유 번호), postNo(게시글의 고유 번호)를 요청 받는다. --%>
      
<%-- postNo 값을 받아, 해당 값을 가진 게시물을 조회하고 화면에 뿌린다. 
     - 추가로 게시글 상세페이지로 넘어 왔을 때, 해당 게시글의 조회 수를 증가시킨다.--%>
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo")); 
	String pageNo = request.getParameter("pageNo");
	String userId = "123@123"; //세션에서 꺼내는 것으로 변경하기.
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	Post post = mapper.selectPostBypostNo(postNo); 

	Map<String,Object> condition = new HashMap<>();
	
	//댓글 조회하기
	condition.put("postNo",postNo);
	List<PostReply> postReplies = mapper.getPostReplies(condition); 
	
	// 조회 수 값을 들어올 때마다 1 증가 시킨다. 
	post.setViewCnt(post.getViewCnt() + 1); 
	// 변경된 값을 updatePost 쿼리문에 적용한다.
	mapper.updatePost(post);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서 문의 상세 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <%@include file="../common/nav.jsp" %>
    <!-- /bookhub/src/main/webapp/common/nav.jsp 
         /bookhub/src/main/webapp/post/book-post-detail.jsp-->

    <!-- Post Detail Content -->
    <div class="container my-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <!-- Post Header -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="card-title mb-0">도서 문의</h4>
                         <!--    <div>
                                <span class="badge bg-primary me-2">공개</span>
                                <span class="badge bg-secondary">답변대기</span>
                            </div> -->
                        </div>
                        <div class="text-muted mb-2">
                            <small><i class="fas fa-book me-1"></i> 문의 도서: <%= post.getBook().getTitle() %></small>
                        </div>
                        <h2 class="mb-3"><%= post.getTitle() %></h2>
                        <div class="d-flex justify-content-between align-items-center text-muted mb-3">
                            <div>
                                <span class="me-3"><i class="fas fa-user me-1"></i><%= post.getUser().getName() %></span>
                                <span><i class="fas fa-calendar me-1"></i>작성일: <%= StringUtils.simpleDate(post.getCreatedDate()) %></span>
                                <span><i class="fas fa-calendar me-1"></i>수정일: <%= StringUtils.simpleDate(post.getUpdatedDate()) %></span>
                                
                            </div>
                            <div>
                                <span class="me-3"><i class="fas fa-eye me-1"></i> <%= post.getViewCnt() %></span>
                            </div>
                        </div>
                        <hr>
                        <div class="mb-4">
                            <h5 class="mb-3">문의 도서</h5>
                            <div class="book-info p-3 bg-light rounded">
                                <div class="row">
                                    <div class="col-md-2">
                                        <img src="<%= post.getBook().getCoverImagePath() %>" alt="책 표지" class="img-fluid">
                                    </div>
                                    <div class="col-md-10">
                                        <h5><%= post.getBook().getTitle() %></h5>
                                        <p class="text-muted mb-2">저자: <%= post.getBook().getAuthor() %></p>
                                        <p class="text-muted mb-2">출판사: <%= post.getBook().getPublisher() %>
                                        <p class="text-muted mb-2">발행일자: <%= post.getBook().getPubDate() %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-4">
                            <h5 class="mb-3">문의 내용</h5>
                            <div class="post-content p-3 bg-light rounded">
                            <p><%= post.getContent() %></p>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <div>
<% if(userId != null && userId.equals(post.getUser().getId())) { %>       
<!-- 세션에서 꺼낸 아이디가 존재하고, 해당 게시글의 유저와 동일한 유저일 경우, 수정 삭제 기능을 구현할 수 있다. -->                 
                                <a href="book-post-modify-form.jsp?postCateNo=<%= postCateNo %>&postNo=<%= postNo %>" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-edit me-1"></i> 수정
                                </a>
                                <a href="book-post-delete.jsp?postCateNo=<%= postCateNo %>&postNo=<%= postNo %>" class="btn btn-outline-secondary"
                                id="del-post-btn">
                                    <i class="fas fa-trash me-1"></i> 삭제
                                </a>
<% } else { %>                      
								<a href="#" class="btn btn-outline-primary me-2 disabled">
                                    <i class="fas fa-edit me-1"></i> 수정
                                </a>
                                <a href="#" class="btn btn-outline-secondary disabled">
                                    <i class="fas fa-trash me-1"></i> 삭제
                                </a>
<% } %>                                  
                            </div>
                        </div>
                    </div>
                </div>

	<!-- 댓글 기능 구현 -->
                <!-- Comments Section -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title mb-4">댓글 (3)</h5>
                     
                        <!-- 댓글 입력하는 공간 -->
                        <form id="reply-add" method="post" action="book-post-detail-reply-add.jsp">
	                       <div class="mb-4">
	                           <textarea name="replyContent" 
	                           			 class="form-control mb-2" 
	                           			 rows="3" 
	                           			 placeholder="댓글을 입력하세요"
	                           			 ></textarea>
	                           <input type="hidden" name="postCateNo" value="<%= postCateNo %>"> 
	                           <input type="hidden" name="postNo" value="<%= postNo %>"> 
	                           <input type="hidden" name="pageNo" value="<%= pageNo %>">
	                            
	                           <div class="d-flex justify-content-end">
	                               <button type="submit" class="btn btn-primary">댓글 등록</button>
	                           </div>
	                       </div>
                        </form>
<% 
	for(PostReply postReply : postReplies) {
		int postReplyNo = postReply.getNo();
%>                           
                        <!-- 댓글 리스트 -->
                        <div class="comments-list">
                            <div class="comment-item mb-1 pb-4 border-bottom">
                                <div class="d-flex justify-content-between mb-2">
                                   <!-- 사용자 이름 및 작성일자.--> 
                                    <div>
                                        <span class="fw-bold"><%=postReply.getUser().getName() %></span>
                                        <span class="text-muted ms-2"><%=StringUtils.simpleDate(postReply.getCreatedDate()) %></span>
                                    </div>
                                    <!-- 답글 및 수정 버튼 -->
				                    <div>
                                        <button type="button" 
                                                class="btn btn-sm btn-link text-muted reply_reply_btn"
                                                data-reply-no="<%=postReplyNo %>">답글</button>
                                        <button type="button" 
                                                class="btn btn-sm btn-link text-muted reply_modify_btn"
                                                data-reply-no="<%=postReplyNo %>">수정</button>
                                        <button type="button" 
                                                class="btn btn-sm btn-link text-danger reply_del_btn"
                                                data-reply-no="<%=postReplyNo %>">삭제</button>
                                    </div> 
                                </div>
                                <!-- 댓글 내용. -->
                                <div id="reply-content-<%=postReplyNo %>">
	                                <p class="mb-0"><%=postReply.getContent() %></p>
                                </div> 
                                <!-- 댓글 수정폼 -->
                                <div class="d-none"
                                     id="reply-modify-container-<%=postReplyNo %>">
                                	<form action="">
                                		<textarea class="form-control mb-2" 
                                				  rows="3"
                                				  name=""></textarea>
                                		<button type="submit" 
                                				class="btn btn-sm btn-link text-muted">등록</button>
	                        			<button type="button" 
	                        					class="btn btn-sm btn-link text-muted reply_modify_cancle_btn"
	                        					data-reply-no=<%=postReplyNo %>>취소</button>
                                	</form>
                                </div>
                                
                                <!-- 답글 입력폼 --> 
                                <div class="d-none"
                                	 id="reply-reply-container">
                                	<form action="">
                                		<textarea class="form-control mb-2" 
                                				  rows="3"></textarea>
                                		<button type="submit" 
                                				class="btn btn-sm btn-link text-muted">등록</button>
	                        			<button type="button" 
	                        					class="btn btn-sm btn-link text-muted reply-reply-cancle-btn"
	                        					data-reply-no=<%=postReplyNo %> >취소</button>
                                	</form>
                                </div>
                                
                            </div>
                        </div>
<%
	}
%>                    
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="d-flex justify-content-between mb-5">
                    <a href="post-list-1.jsp?postCateNo=<%= postCateNo %>&pageNo=<%=pageNo %>" class="btn btn-outline-secondary"> 
                        <i class="fas fa-arrow-left me-1"></i> 목록으로
                    </a>
                   <!--  <div>
                        <a href="#" class="btn btn-outline-primary me-2">
                            <i class="fas fa-arrow-up me-1"></i> 이전 글
                        </a>
                        <a href="#" class="btn btn-outline-primary">
                            다음 글 <i class="fas fa-arrow-down ms-1"></i>
                        </a>
                    </div> -->
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
 	<%@include file="../common/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function () {
    		//게시글 삭제 버턴 눌렀을 때 이벤트
	    	$("#del-post-btn").click(function () { 
	    		let result = confirm("정말 삭제하시겠습니까?");
	    		return result;
			});
    	/* 예를 누르면 result 값이 true. 
    	   아니오를 누르면 result 값이 false로 반환.*/
    	   
	    	   // 댓글에서 수정 버튼을 누르게 되면
	    	   $(".reply_modify_btn").click(function() {
	    		   // 해당 이벤트의 data 값인 댓글의 고유 넘버를 꺼낸다.
	    		   const replyNo = $(this).data("reply-no");
	    		   
	    		   // 댓글 내용이 담긴 선택자를 선택. 
	    		   const $replyContent = $("#reply-content-"+replyNo);
	    		   
	    		   //댓글 내용을 추출한다.
	    		   const replyContentData = $replyContent.find("p").text();
	    		   
	    		   // 해당 댓글의 수정폼 선택자를 선택.
	    		   const $replyModifyContainer =$("#reply-modify-container-"+replyNo);
	    		   
	    		   //수정폼 선택자의 textarea에 댓글 내용을 넣는다.
	    		   $replyModifyContainer.find("textarea").val(replyContentData);
	    		   
	    		   // 기존 댓글 화면을 안보이게 한다.
	    		   $replyContent.addClass("d-none");
	    		   
	    		   //이 상태인 수정폼을 보이게 한다.
	    		   $replyModifyContainer.removeClass("d-none");
				});
    			
    			// 수정 폼에서 취소 버튼을 누르면 다시 원래대로 되돌아 온다.
				$(".reply_modify_cancle_btn").click(function () {
					
					// 댓글 고유 넘버를 뽑아온다. 
					const replyNo = $(this).data("reply-no");
					
					//수정폼을 선택한다. 
					const $replyModifyContainer = $("#reply-modify-container-"+replyNo);
					
					//댓글 내용 선택자를 선택한다.
					const $replyContent = $("#reply-content-"+replyNo);
					
					$replyModifyContainer.addClass("d-none");
					
					$replyContent.removeClass("d-none"); 
				});
    		 
	    	   
	    	
	    	 // 댓글 등록 할 때
	    	$("#reply-add").submit(function () {
	    		const replyContent = $("textarea[name=replyContent]").val();
	    		
	    		if(!replyContent.trim() || replyContent.trim() === "") {
	    			alert("댓글을 입력해주세요.");
	    			return false;
	    		}
			});
		});
    	   
    	
    </script>
</body>
</html> 