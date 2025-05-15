<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String postCateNo = request.getParameter("postCateNo");
	int postNo = StringUtils.strToInt(request.getParameter("postNo")); 
	String pageNo = request.getParameter("pageNo");
	String userId = (String)session.getAttribute("LOGINED_USER_ID"); //세션에서 꺼내는 것으로 변경하기.
	
	int currentPageNo = StringUtils.strToInt(request.getParameter("currentPageNo"),1); 
	
	//단일의 게시글을 조회.
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	Post post = mapper.getLibPostBypostNo(postNo); 

	//map 객체 생성
	Map<String,Object> condition = new HashMap<>(); 
	
	
	condition.put("postNo",postNo);
	
	//부모 댓글의 총 개수
	int totalRowsParentReply = mapper.totalRowsParentReply(condition);
	
	// 페이징 객체 생성
	Pagination pnt = new Pagination(currentPageNo,totalRowsParentReply,5);
	condition.put("offset",pnt.getOffset());
	condition.put("rows",pnt.getRows());
	
	// 부모 댓글들을 조회한다.
	List<PostReply> parentReplies = mapper.getParentPostReplies(condition); 
	
	
	// 조회 수 값을 들어올 때마다 1 증가 시킨다. 
	post.setViewCnt(post.getViewCnt() + 1); 
	// 변경된 값을 updatePost 쿼리문에 적용한다.
	mapper.updatePostViewCnt(post);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서관 문의 상세 - 북허브</title>
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
                            <small><i class="fas fa-book me-1"></i> 문의 도서관: <%= post.getLibrary().getName() %></small>
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
                            <h5 class="mb-3">문의 도서관</h5>
                            <div class="book-info p-3 bg-light rounded">
                                <div class="row">
                                    <div class="col-md-2">
                                        <img src="<%=post.getLibrary().getImgPath() %>" alt="도서관 소개 표지" class="img-fluid">
                                    </div>
                                    <div class="col-md-10">
                                        <h5><%= post.getLibrary().getName() %></h5>
                                        <p class="text-muted mb-2">주소: <%= post.getLibrary().getLocation() %></p>
                                        <p class="text-muted mb-2">전화번호: <%= post.getLibrary().getTel() %>
                                        <p class="text-muted mb-2">운영시간: <%= post.getLibrary().getBusinessHours() %></p>
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
                                <a href="lib-post-modify-form.jsp?postCateNo=<%= postCateNo %>&postNo=<%= postNo %>" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-edit me-1"></i> 수정
                                </a>
                                <a href="lib-post-delete.jsp?postCateNo=<%= postCateNo %>&postNo=<%= postNo %>" class="btn btn-outline-secondary"
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
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title mb-4">댓글</h5>
                     
                        <!-- 댓글 입력하는 공간 -->
                        <form id="reply-add" method="post" action="post-detail-reply-add.jsp">
	                       <div class="mb-4">
	                           <textarea name="replyContent" 
	                           			 class="form-control mb-2" 
	                           			 rows="3" 
	                           			 placeholder="댓글을 입력하세요"></textarea>
	                           <input type="hidden" name="postCateNo" value="<%= postCateNo %>"> 
	                           <input type="hidden" name="postNo" value="<%= postNo %>"> 
	                           <input type="hidden" name="pageNo" value="<%= pageNo %>">
	                            
	                           <div class="d-flex justify-content-end">
	                               <button type="submit" class="btn btn-primary <%= userId == null ? "disabled": "" %>">댓글 등록</button>
	                           </div>
	                       </div>
                        </form>
                        
                        <div id="comments-box">
<% 
	for(PostReply parentReply : parentReplies) {
		int postReplyNo = parentReply.getNo();
%>                           
	                        <!-- 댓글 리스트 -->
	                        <div class="comments-list">
	                            <div class="comment-item mb-1 pb-4 border-bottom">
	                                <div class="d-flex justify-content-between mb-2">
	                                   <!-- 사용자 이름 및 작성일자.--> 
	                                    <div>
	                                        <span class="fw-bold"><%=parentReply.getUser().getName() %></span>
	                                        <span class="text-muted ms-2"><%=StringUtils.simpleDate(parentReply.getCreatedDate()) %></span>
	                                    </div>
	                                    
	                                    <!-- 답글 및 수정 버튼, 단 삭제될 경우 아래 버튼이 삭제된다. -->
					                    <div class=" <%="Y".equals(parentReply.getIsDeleted()) ? "d-none" : "" %>">
	                                        <button type="button" 
	                                                class="btn btn-sm btn-link text-muted <%=userId == null ? "disabled": ""  %> reply_reply_btn"
	                                                data-reply-no="<%=postReplyNo %>">답글</button>
	                                        <button type="button" 
	                                                class="<%=userId !=null && userId.equals(parentReply.getUser().getId()) ?  "" : "disabled"  %> btn btn-sm btn-link text-muted reply_modify_btn"
	                                                data-reply-no="<%=postReplyNo %>">수정</button>
	                                        
	                                        <a class="<%=userId !=null && userId.equals(parentReply.getUser().getId()) ?  "" : "disabled"  %> btn btn-sm btn-link text-danger reply_del_btn"
	                                           href="post-detail-reply-delete.jsp?postCateNo=<%=postCateNo %>&postNo=<%=postNo %>&pageNo=<%=pageNo %>&postReplyNo=<%=postReplyNo %>"
	                                           data-reply-no="<%=postReplyNo %>">삭제</a>
	                                    </div> 
	                                </div>
	                                
	                                <div id="reply-content-<%=postReplyNo %>">
		                                <p class="mb-0"><%="N".equals(parentReply.getIsDeleted()) ? parentReply.getContent() : "삭제된 댓글입니다." %></p>
		                                <button type="button" 
		                                		class="btn btn-sm px-1 py-0 fw-light more_reply"
		                                		data-post-reply="<%=postReplyNo %>">답글 더보기</button>
		                                <button type="button" 
		                                		class="btn btn-sm px-1 py-0 fw-light d-none fold_reply"
		                                		data-post-reply="<%=postReplyNo %>">접기</button>
		                                <div class="child_reply d-none">
		                                
		                                </div>
	                                </div> 
	                          
	                                <!-- 댓글 수정폼 -->
	                                <div class="d-none"
	                                     id="reply-modify-container-<%=postReplyNo %>">
	                                	<form method="post" action="post-detail-reply-modify.jsp">
	                                		<input type="hidden" name="postCateNo" value="<%=postCateNo %>">
	                                		<input type="hidden" name="postNo" value="<%=postNo %>">
	                                		<input type="hidden" name="pageNo" value="<%=pageNo %>">
	                                		<input type="hidden" name="postReplyNo" value="<%=postReplyNo %>"> 
	                                		
	                                		<textarea class="form-control mb-2" 
	                                				  rows="3"
	                                				  name="replyModifyContent"></textarea>
	                                		<button type="submit" 
	                                				class="btn btn-sm btn-link text-muted">등록</button>
		                        			<button type="button" 
		                        					class="btn btn-sm btn-link text-muted reply_modify_cancle_btn"
		                        					data-reply-no=<%=postReplyNo %>>취소</button>
	                                	</form>
	                                </div>
	                                
	                                <!-- 답글 입력폼: --> 
	                                <div class="d-none"
	                                	 id="reply-reply-container-<%=postReplyNo %>">
	                                	<form method="post" action="post-detail-reply-add.jsp">
	                                        <input type="hidden" name="postCateNo" value="<%=postCateNo %>">
	                                		<input type="hidden" name="postNo" value="<%=postNo %>">
	                                		<input type="hidden" name="pageNo" value="<%=pageNo %>">
	                                		<input type="hidden" name="postReplyNo" value="<%=postReplyNo %>"> 
	                                		
	                                		<textarea class="form-control mb-2" 
	                                				  rows="3"
	                                				  name="replyReplyContent"></textarea>
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
						<button type="button"
                                class="btn btn-outline-secondary <%=totalRowsParentReply > pnt.getRows() ? "": "disabled" %>"
                                id="more-parent-reply"
                                data-post-no="<%=postNo %>"
                                data-page-no="<%=currentPageNo %>" 
                                data-total-pages="<%=pnt.getTotalPages()  %>">더보기</button>               
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="d-flex justify-content-between mb-5">
                    <a href="post-list-2.jsp?postCateNo=<%= postCateNo %>&pageNo=<%=pageNo %>" class="btn btn-outline-secondary"> 
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
     	   const postCateNo = "<%=postCateNo %>";
    	   const postNo = "<%=postNo %>";
    	   const pageNo = "<%=pageNo %>";
    	   const userId = "<%=userId %>"
    		
    		//게시글 삭제 버턴 눌렀을 때 이벤트
	    	$("#del-post-btn").click(function () { 
	    		let result = confirm("정말 삭제하시겠습니까?");
	    		return result;
			});
    	   		
    	   		$(".reply_del_btn").click(function() {
					let result = confirm("정말 삭제하시겠습니까?");
					return result;
				});
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
    			
    			// 댓글에서 답글 버튼 눌렀을 대
    			$(".reply_reply_btn").click(function () {
					// 해당 버튼의 data 속성값 추출 - 댓글 고유 넘버 
					const replyNo = $(this).data("reply-no");
					
					// 답글 입력폼 선택
					const $replyReplyContainer = $("#reply-reply-container-"+replyNo);
					
					$replyReplyContainer.removeClass("d-none");
				}); 
    			
    			// 답글 버튼의 취소 버튼을 누를 때
    			$(".reply-reply-cancle-btn").click(function () {
    				const replyNo = $(this).data("reply-no");
    				const $replyReplyContainer = $("#reply-reply-container-"+replyNo);
    				$replyReplyContainer.addClass("d-none");
				});
    			
    			// 댓글에서 답글 더보기 기능
    			$(".more_reply").click(function () {
    				const postReplyNo = $(this).data("post-reply"); 
    				const $childContainer = $(this).siblings(".child_reply");
    				const $foldReply = $(this).siblings(".fold_reply");
    				
    				// 대댓글 섹션 보이게 하기
    				$childContainer.removeClass("d-none");
    				
    				//더보기 버튼 화면에서 가리기
    				$(this).addClass("d-none");
    				
    				//접기 버튼 화면에 보여주기
    				$foldReply.removeClass("d-none");
    				
    				$.ajax({
    					 type: "get",
    					url : "get-child-replies.jsp",
    					data : {postReplyNo : postReplyNo},
    					dataType : "json",
    					success: function(childReplies) {
							for(let reply of childReplies) {
								let $div = $childContainer.empty();
								let content = `
										<div>
		                                	<span class="fw-bold">&nbsp;&nbsp;&nbsp;&nbsp;\${reply.user.name}</span>
		                                	<span class="fw-bold">&nbsp;&nbsp;&nbsp;\${reply.createdDate}</span>
		                            	</div>
		                            	<div class="comment-item mb-1 pb-3 border-bottom">
											<p class="mb-0">&nbsp;&nbsp;&nbsp;ㄴ&nbsp;\${reply.content}</p>
										</div>`; 
								$div.append(content);
							}
						}
    				}) // ajax 종료
				});
    			
    			// 접기 버튼을 눌렀을 때
    			$(".fold_reply").click(function () {
					$(this).siblings(".child_reply").addClass("d-none");
					$(this).siblings(".more_reply").removeClass("d-none");
					$(this).addClass("d-none");
				});
    			
    			let totalRowsParentReply = "<%=totalRowsParentReply %>";
    			let totalPages = "<%=pnt.getTotalPages() %>"
    			
    			// 더보기 버튼을 눌렀을 때 조회되는 댓글을 다섯개씩 붙히기.
    			$("#more-parent-reply").click(function() {
    				const $moreBtn = $(this);
					let currentPageNo = parseInt($(this).attr("data-page-no"))+1; 
					const dataTotalPages = parseInt($(this).attr("data-total-pages"));
					console.log("currentPageNo",currentPageNo)
					console.log("dataTotalPages",dataTotalPages)
					
					if(currentPageNo === dataTotalPages) {
						$moreBtn.addClass("d-none");
					}
					$.ajax({
						type: "get", 
						url: "get-parent-replies.jsp",
						data: {postNo : postNo,
							currentPage : currentPageNo},
						dataType: "json", 
						success: function (parentReplies) {
							for(let parentReply of parentReplies) {
								let item = `
									<div class="comments-list">
		                            <div class="comment-item mb-1 pb-4 border-bottom">
		                                <div class="d-flex justify-content-between mb-2">
		                                   <!-- 사용자 이름 및 작성일자.--> 
		                                    <div>
		                                        <span class="fw-bold">\${parentReply.user.name}</span>
		                                        <span class="text-muted ms-2">\${parentReply.createdDate}</span>
		                                    </div>
		                                    
		                                    <!-- 답글 및 수정 버튼, 단 삭제될 경우 아래 버튼이 삭제된다. -->
						                    <div class="\${parentReply.isDeleted === 'Y' ? 'd-none' : ''}">
		                                        <button type="button" 
		                                                class="btn btn-sm btn-link text-muted reply_reply_btn"
		                                                data-reply-no="\${parentReply.no}">답글</button>
		                                        <button type="button" 
		                                                class="\${userId != null && userId === parentReply.user.id ?  '' : 'disabled'} btn btn-sm btn-link text-muted reply_modify_btn"
		                                                data-reply-no="\${parentReply.no}">수정</button>
		                                        
		                                        <a class="\${userId != null && userId === parentReply.user.id ?  '' : 'disabled'} btn btn-sm btn-link text-danger reply_del_btn"
		                                           href="post-detail-reply-delete.jsp?postCateNo=\${postCateNo}&postNo=\${postNo}&pageNo=\${pageNo}&postReplyNo=\${parentReply.no}"
		                                           data-reply-no="\${parentReply.no}">삭제</a>
		                                    </div> 
		                                </div>
		                                <!-- 댓글 내용 : 삭제되지 않은 댓글과 삭제된 댓글을 표시함.-->
		                                <div id="reply-content-\${parentReply.no}">
			                                <p class="mb-0">\${parentReply.isDeleted === 'N' ? parentReply.content : '삭제된 댓글입니다.'}</p>
			                                <button type="button" 
			                                		class="btn btn-sm px-1 py-0 fw-light more_reply"
			                                		data-post-reply="\${parentReply.no}">답글 더보기</button>
			                                <button type="button" 
			                                		class="btn btn-sm px-1 py-0 fw-light d-none fold_reply"
			                                		data-post-reply="\${parentReply.no}">접기</button>
			                                <div class="child_reply d-none">
			                                
			                                </div>
		                                </div> 
		                          
		                                <!-- 댓글 수정폼 -->
		                                <div class="d-none"
		                                     id="reply-modify-container-\${parentReply.no}">
		                                	<form method="post" action="post-detail-reply-modify.jsp">
		                                		<input type="hidden" name="postCateNo" value="\${postCateNo}">
		                                		<input type="hidden" name="postNo" value="\${postNo}">
		                                		<input type="hidden" name="pageNo" value="\${pageNo}">
		                                		<input type="hidden" name="postReplyNo" value="\${parentReply.no}"> 
		                                		
		                                		<textarea class="form-control mb-2" 
		                                				  rows="3"
		                                				  name="replyModifyContent"></textarea>
		                                		<button type="submit" 
		                                				class="btn btn-sm btn-link text-muted">등록</button>
			                        			<button type="button" 
			                        					class="btn btn-sm btn-link text-muted reply_modify_cancle_btn"
			                        					data-reply-no="\${parentReply.no}">취소</button>
		                                	</form>
		                                </div>
		                                
		                                <!-- 답글 입력폼: --> 
		                                <div class="d-none"
		                                	 id="reply-reply-container-\${parentReply.no}">
		                                	<form method="post" action="post-detail-reply-add.jsp">
		                                        <input type="hidden" name="postCateNo" value="\${postCateNo}">
		                                		<input type="hidden" name="postNo" value="\${postNo}">
		                                		<input type="hidden" name="pageNo" value="\${pageNo}">
		                                		<input type="hidden" name="postReplyNo" value="\${parentReply.no}"> 
		                                		
		                                		<textarea class="form-control mb-2" 
		                                				  rows="3"
		                                				  name="replyReplyContent"></textarea>
		                                		<button type="submit" 
		                                				class="btn btn-sm btn-link text-muted">등록</button>
			                        			<button type="button" 
			                        					class="btn btn-sm btn-link text-muted reply-reply-cancle-btn"
			                        					data-reply-no="\${parentReply.no}" >취소</button>
		                                	</form>
		                                </div>
		                                
		                            </div> 
		                        </div>`;

		                        $("#comments-box").append(item);
		                        $moreBtn.attr("data-page-no", parseInt(currentPageNo));   
							}
						}
					})
					
				}); // ajax 종료
    			
	    	
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