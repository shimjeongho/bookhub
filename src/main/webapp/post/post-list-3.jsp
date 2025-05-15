<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.vo.Post"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// 서버 값 추출
	PostMapper selectPost = MybatisUtils.getMapper(PostMapper.class);
	int postCateNo = StringUtils.strToInt(request.getParameter("postCateNo"));
	int pageNo = StringUtils.strToInt(request.getParameter("pageNo"), 1);
	String searchType = StringUtils.nullToBlank(request.getParameter("searchType"));
	String searchKeyword = StringUtils.nullToBlank(request.getParameter("searchKeyword"));
	String sort = StringUtils.nullToStr(request.getParameter("sort"), "newest");
	String userId = (String)session.getAttribute("LOGINED_USER_ID"); 
	
	//map 객체 생성 및 할당과 페이징 처리한 값도 같이 할당
	Map<String, Object> conditon = new HashMap<>();

	conditon.put("postCateNo", postCateNo);

	if (!searchType.isEmpty() && !searchKeyword.isEmpty()) {
		conditon.put("searchType", searchType);
		conditon.put("searchKeyword", searchKeyword);
	}

	conditon.put("pageNo", pageNo);
	
	conditon.put("sort",sort != null ? sort : "newest");

	int totalRows = selectPost.getTotalRows(conditon);

	Pagination pnt = new Pagination(pageNo, totalRows);

	conditon.put("offset", pnt.getOffset());
	conditon.put("rows", pnt.getRows());
	
	//리스트 뿌리기
	List<Post> posts = selectPost.getSystemPost(conditon);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>기타 시스템 문의 게시판 - 북허브</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<!-- Custom CSS -->
<link href="../resources/css/styles.css" rel="stylesheet">

</head>
<body>
	<%@include file="../common/nav.jsp"%>

	<!-- Board Content -->
	<div class="board-container">
		<!-- Board Header -->
		<div class="card mb-4">
			<div class="card-body">
			    <div class="row align-items-center">
			        <div class="col-md-3">
			            <h4 class="card-title mb-0">기타 시스템 문의 게시판</h4>
			        </div>
			        <div class="col-md-9">
			            <div class="d-flex justify-content-end align-items-center gap-2">
			                <form method="get" id="form-post-list" class="d-flex align-items-center"> 
			                	<!-- 정렬 셀렉트 박스 -->
			                    <select class="form-select form-select-sm me-2" id="sort-select" name="sort" style="width: 100px;">
        							<option value="newest" <%= "newest".equals(request.getParameter("sort")) ? "selected" : "" %>>최신순</option>
       								<option value="views" <%= "views".equals(request.getParameter("sort")) ? "selected" : "" %>>조회수 순</option>
    							</select>
    							
			                	<!-- 검색유형 셀렉트 박스 -->
			                    <select class="form-select form-select-sm me-2" id="search-type" name="searchType" style="width: 100px;">
			                        <option value="title" <%="title".equals(searchType) ? "selected" : ""%>>제목</option>
			                        <option value="user" <%="user".equals(searchType) ? "selected" : ""%>>작성자</option>
			                    </select>
			                    
			                    <!-- 검색어 입력 -->
			                    <input type="text" class="form-control form-control-sm me-2" id="post-search-keyword" 
			                           placeholder="검색어 입력" name="searchKeyword" value="<%=searchKeyword%>" style="width: 200px;">
			                    
			                    <!-- 숨김필드 -->
			                    <input type="hidden" name="postCateNo" value="<%=postCateNo%>">
			                    <input type="hidden" name="pageNo" value="<%=pageNo%>">
			                    
			                    <button class="btn btn-primary btn-sm" id="search-btn" name="searchBtn">
			                        <i class="fas fa-search"></i>
			                    </button>
			                </form>			                
			                <a id="write-btn" 
			                   href="system-post-form.jsp?postCateNo=<%=postCateNo %>" 
			                   class="btn btn-primary btn-sm <%= userId == null ? "disabled" : ""%>">
			                    <i class="fas fa-pen"></i> 글쓰기
			                </a>
			            </div>
			        </div>
			    </div>
			</div>
		</div>


		<!-- Post List -->
		<div class="card">
			<div class="card-body p-0">
				<div class="table-responsive">
					<table class="table table-hover mb-0">
						<colgroup>
							<col width="10%" />
							<col width="*" />
							<col width="10%" />
							<col width="10%" />
							<col width="15%" />
						</colgroup>
						<thead class="table-light">
							<tr>
								<th scope="col" class="text-center" >번호</th>
								<th scope="col">제목</th>
								<th scope="col" class="text-center" >작성자</th>
								<th scope="col" class="text-center" >작성일</th>
								<th scope="col" class="text-center" >조회</th>
							</tr>
						</thead>
						
						<tbody id="post-list">
<%
	for (Post post : posts) {
		if("Y".equals(post.getIsPublic())) {
%>
							<tr id="post-list-info">
								<td class="text-center"><%=post.getNo()%></td>
								<td><a
									href="system-post-detail.jsp?postCateNo=<%=postCateNo%>&postNo=<%=post.getNo()%>&pageNo=<%=pageNo%>"
									class="post-title"><%=post.getTitle()%></a> <!-- 요청할 파라미터가 여러 개인 경우 '?'가 아닌 '&'로 붙힌다. -->
								</td>
								<td class="text-center"><%=post.getUser().getName()%></td>
								<td class="text-center"><%=StringUtils.simpleDate((post.getCreatedDate()))%></td>
								<td class="text-center"><%=post.getViewCnt()%></td>
							</tr>
<%
		} else { 
%>			
							<tr id="post-list-info">
								<td class="text-center"><%=post.getNo()%></td>
<% 	       
			if (userId != null && userId.equals(post.getUser().getId())) {
%>
								<td>
								<a href="system-post-detail.jsp?postCateNo=<%=postCateNo%>&postNo=<%=post.getNo()%>&pageNo=<%=pageNo%>"
								   class="post-title">비공개 게시글입니다.</a> 
								</td>
<% 
			}else  {
%>
								<td>
								<a href="system-post-detail.jsp?postCateNo=<%=postCateNo%>&postNo=<%=post.getNo()%>&pageNo=<%=pageNo%>"
								   class="post-title-disabled text-secondary">비공개 게시글입니다.</a> 
								</td>
<%
			}
%>
								<td class="text-center"><%= post.getUser().getName() %></td>
								<td class="text-center"><%=StringUtils.simpleDate((post.getCreatedDate()))%></td>
								<td class="text-center"><%=post.getViewCnt()%></td>
							</tr>
<%
		}
	}
%>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- Pagination -->
<%
	if (totalRows > 0) {
%>
		<nav class="mt-4">
			<ul id="page-id" class="pagination justify-content-center">
<%
		if (!pnt.isFirst()) {
%>
				<li class="page-item"><a href="?page=<%=pnt.getPrevPage()%>"
					class="page-link" data-page-no="<%=pnt.getPrevPage()%>">이전</a></li>
<%
		}

		int currentPage = pnt.getCurrentPage();
		int beginPage = pnt.getBeginPage();
		int endPage = pnt.getEndPage();
		for (int num = beginPage; num <= endPage; num++) {
			
			if (num == currentPage) {
%>
				<li class="page-item active"><span class="page-link"><%=num%></span>
				</li>
<%
			}else {
%>
				<li class="page-item"><a href="?page=<%=num%>"
					class="page-link" data-page-no="<%=num%>"><%=num%></a></li>
<%
			}
		}

		if (!pnt.isLast()) {
%>
				<li class="page-item <%=pnt.isLast() ? "disabled" : ""%>"><a
					href="?page=<%=pnt.getNextPage()%>" class="page-link"
					data-page-no="<%=pnt.getNextPage()%>">다음</a></li>
<%
		}
%>
			</ul>
		</nav>
<%
}
%>
	</div>
	<!-- Footer -->
	<%@include file="../common/footer.jsp"%>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		const $formPostList = $("#form-post-list");
		
		//페이지 번호를 눌렀을 때, 거기서의 pageNo값을 뽑아서, 서버에 제출, 
		//그리고 링크 이기 때문에 기본 동작을 막는 return false를 작성한다.
		$("#page-id .page-link").click(function() {
			const pageNo = $(this).data("page-no");
			$formPostList.find("input[name=pageNo]").val(pageNo);

			$formPostList.trigger("submit");
			return false;
		});
		
		$("#sort-select").change(function() {
			$formPostList.find("input[name=pageNo]").val(1);
			$formPostList.trigger("submit");
		}); 
		
		//비공개 게시글 중, 본인 사용자가 아닌 경우 게시글의 제목부를 클릭햇을 때 일어나는 이벤트임.
		// 권한이 없다는 알림창을 주고, return false로 기본 동작을 할 수 없도록 한다.
		$(".post-title-disabled").click(function () {
			alert("열람 권한이 없습니다.");
			return false;
		}); 
	</script>
</body>
</html>
