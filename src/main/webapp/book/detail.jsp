<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="kr.co.bookhub.vo.Category"%>
<%@page import="kr.co.bookhub.vo.BookReview"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="kr.co.bookhub.mapper.BookReviewMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.BookMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// bno
	int bookNo = StringUtils.strToInt(request.getParameter("bno"));
	
	// 요청 파라미터 조회(페이지네이션)
	int pageNo = StringUtils.strToInt(request.getParameter("page"), 1);
	String sort = StringUtils.nullToStr(request.getParameter("sort"), "newest");
	
	// Map 객체 생성
	Map<String, Object> condition = new HashMap<>();
	// 적절한 필터링 조건 Map에 담기
	condition.put("page", pageNo);
	condition.put("sort", sort);
	condition.put("bookNo", bookNo);
	
	// 리뷰 등록후 완료 알림
	String complete = (String) session.getAttribute("complete");
	session.removeAttribute("complete");
	
	// 리뷰 삭제후 완료 알림
	String delete = (String) session.getAttribute("delete");
	session.removeAttribute("complete");
	
	// 구현객체 가져오기
	BookMapper bookMapper = MybatisUtils.getMapper(BookMapper.class);
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
	
	Book book = bookMapper.getBookByNo(bookNo);
	
	// 총 리뷰 개수 조회
	int totalRows = bookReviewMapper.getTotalRows(bookNo);
	// 페이지네이션 객체를 생성
	Pagination pagination = new Pagination(pageNo, totalRows);
	// 필터링 조건에 offset과 rows를 추가
	condition.put("offset", pagination.getOffset());
	condition.put("rows", pagination.getRows());
	// 필터링 조건에 맞는 리뷰목록 조회
	List<BookReview> bookReviews = bookReviewMapper.getBookReviewsByBookNo(condition);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>북허브 - 상세</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
    <!-- /bookhub/src/main/webapp/resources/css/styles.css
     /bookhub/src/main/webapp/book/detail.jsp-->
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="home.html">우도도서관</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#">자료검색</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">이용안내</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="#">게시판</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">도서관소개</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="login.html">로그인</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="signup.html">회원가입</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Detail Content -->
    <div class="detail-container">
        <div class="row">
            <!-- Book Cover -->
            <div class="col-md-4 book-info">
                <img src="<%=book.getCoverImagePath() %>" alt="<%=book.getTitle() %> 책 표지" class="img-fluid book-cover">
            </div>
         
            <!-- Book Information -->
            <div class="col-md-8">
                <div class="book-info">
                    <h1 class="book-title"><%=book.getTitle() %></h1>
                    <div class="book-meta">
                        <p><strong>저자:</strong> <%=book.getAuthor() %></p>
                        <p><strong>출판사:</strong> <%=book.getPublisher() %></p>
                        <p><strong>출판년도:</strong> <%=book.getPubDate() %></p>
                        <p><strong>ISBN:</strong> <%=book.getIsbn() %></p>
                        <p><strong>분류:</strong> <%=book.getCategory().getName() %></p>
                        <p class="d-flex align-items-center">
                            <strong class="me-2">평균 평점:</strong>
                           <%
	                            double avg = book.getReviewAvg();   // DB에서 조회된 값
	                            int total = book.getReviewCount();  // DB에서 리뷰 개수 조회
                           %>
                           
                            <span class="text-warning me-2">
                               <% for (int i = 1; i <= 5; i++) {
						               if (avg >= i) { %>
						                   <i class="fas fa-star"></i>
						        <%     } else if (avg >= i - 0.5) { %>
						                   <i class="fas fa-star-half-alt"></i>
						        <%     } else { %>
						                   <i class="far fa-star"></i>
						        <%     }
						           } %>
                            </span>
                            <span class="text-muted">(<%=book.getReviewAvg() %> / <%=book.getReviewCount() %>명)</span>
                        </p>
                    </div>
                    <div class="availability">
                        <span class="badge bg-success availability-badge">대출 가능</span>
                    </div>
                    
                    <div class="action-buttons">
                        <div class="mb-3">
                            <select class="form-select" id="librarySelect">
                                <option value="">도서관을 선택하세요</option>
                                <option value="central">LG상남도서관 (재고: 4권)</option>
                                <option value="west">우리소리도서관 (재고: 2권)</option>
                                <option value="east">서울특별시교육청 정독도서관 (재고: 1권)</option>
                                <option value="south">서울특별시교육청 어린이도서관 (재고: 3권)</option>
                                <option value="south">삼청공원숲속도서관 (재고: 0권)</option>
                            </select>
                        </div>
                        <button class="btn btn-primary me-2" id="borrowButton" disabled>
                            <i class="fas fa-book"></i> 대여하기
                        </button>
                        <button class="btn btn-outline-secondary">
                            <i class="fas fa-heart"></i> 찜하기
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Description Section -->
        <div class="description-section">
            <h3>도서 소개</h3>
            <p><%=book.getDescription() %></p>
            
        </div>

<%
    int[] stars = new int[5]; // 5점, 4점, 3점, 2점, 1점 순서
   

    for (BookReview review : bookReviews) {
        int star = review.getStar();
        if (star >= 1 && star <= 5) {
            stars[5 - star]++;
        }
    }

    // 퍼센트 계산
    int[] percents = new int[5];
    for (int i = 0; i < 5; i++) {
        percents[i] = total == 0 ? 0 : (int) Math.round((stars[i] * 100.0) / total);
    }
%>

        <!-- Review Section -->
        <div class="review-section mt-5">
            <h3>도서 리뷰</h3>
            
            <!-- Review Summary -->
            <div class="review-summary mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <h2 class="mb-0"><%=book.getReviewAvg() %></h2>
						    <div class="text-warning">
						        <% for (int i = 1; i <= 5; i++) {
						               if (avg >= i) { %>
						                   <i class="fas fa-star"></i>
						        <%     } else if (avg >= i - 0.5) { %>
						                   <i class="fas fa-star-half-alt"></i>
						        <%     } else { %>
						                   <i class="far fa-star"></i>
						        <%     }
						           } %>
						    </div>
                        <small class="text-muted">총 <%=book.getReviewCount() %>개의 리뷰</small>
                    </div>
                 		<div class="ms-3">
					    <div class="d-flex align-items-center mb-1">
					        <small class="me-2">5점</small>
					        <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
					            <div class="progress-bar bg-warning" style="width: <%=percents[0] %>%"></div>
					        </div>
					        <small class="ms-2"><%=percents[0] %>%</small>
					    </div>
					
					    <div class="d-flex align-items-center mb-1">
					        <small class="me-2">4점</small>
					        <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
					            <div class="progress-bar bg-warning" style="width: <%=percents[1] %>%"></div>
					        </div>
					        <small class="ms-2"><%=percents[1] %>%</small>
					    </div>
					
					    <div class="d-flex align-items-center mb-1">
					        <small class="me-2">3점</small>
					        <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
					            <div class="progress-bar bg-warning" style="width: <%=percents[2] %>%"></div>
					        </div>
					        <small class="ms-2"><%=percents[2] %>%</small>
					    </div>
					
					    <div class="d-flex align-items-center mb-1">
					        <small class="me-2">2점</small>
					        <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
					            <div class="progress-bar bg-warning" style="width: <%=percents[3] %>%"></div>
					        </div>
					        <small class="ms-2"><%=percents[3] %>%</small>
					    </div>
					
					    <div class="d-flex align-items-center">
					        <small class="me-2">1점</small>
					        <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
					            <div class="progress-bar bg-warning" style="width: <%=percents[4] %>%"></div>
					        </div>
					        <small class="ms-2"><%=percents[4] %>%</small>
					    </div>
					</div>

                </div>
            </div>

            <!-- Write Review -->
            <div class="write-review mb-4">
                <h4>리뷰 작성하기</h4>
                <form id="reviewForm" method="post" action="review-add.jsp">
                	<input type="hidden" name="bookNo" value="<%=book.getNo()%>">
                    <div class="mb-3">
                        <label class="form-label">평점</label>
                        <div class="rating">
                            <input type="radio" name="star" value="5" id="5" checked><label for="5"><i class="fas fa-star"></i></label>
                            <input type="radio" name="star" value="4" id="4"><label for="4"><i class="fas fa-star"></i></label>
                            <input type="radio" name="star" value="3" id="3"><label for="3"><i class="fas fa-star"></i></label>
                            <input type="radio" name="star" value="2" id="2"><label for="2"><i class="fas fa-star"></i></label>
                            <input type="radio" name="star" value="1" id="1"><label for="1"><i class="fas fa-star"></i></label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="reviewTitle" class="form-label">제목</label>
                        <input type="text" class="form-control" name="title" id="reviewTitle" placeholder="리뷰 제목을 입력하세요">
                    </div>
                    <div class="mb-3">
                        <label for="reviewContent" class="form-label">내용</label>
                        <textarea class="form-control" name="content" id="reviewContent" rows="4" placeholder="이 책에 대한 의견을 자유롭게 작성해주세요"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">리뷰 등록</button>
                </form>
            </div>

            <!-- Review List -->
            <div class="review-list" id="review-list">
                <h4>최신 리뷰 (<%=StringUtils.commaWithNumber(book.getReviewCount()) %> 개)</h4>
			     <form id="form-filter" method="get" action="detail.jsp">
			       <input type="hidden" name="page" value="1">
			       <input type="hidden" name="nextPage" value="<%=pagination.getNextPage()%>">
			       <input type="hidden" name="bno" value="<%=request.getParameter("bno") %>">
			       <input type="hidden" name="totalRows" value="<%=totalRows %>">
			            <div class="col-md-2">
			                <select class="form-select" name="sort">
			                    <option value="newest"		<%="newest".equals(sort) ? "selected" : "" %>>최신순</option>
			                    <option value="oldest" 	<%="oldest".equals(sort) ? "selected" : "" %>>오래된순</option>
			                    <option value="star" 	<%="star".equals(sort) ? "selected" : "" %>>별점순</option>
			                    <option value="likes" 		<%="likes".equals(sort) ? "selected" : "" %>>좋아요순</option>
			                </select>
			            </div>
			      </form>
<%
	for (BookReview review : bookReviews) {
%>   
                <div class="review-item border-bottom py-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div>
                            <span class="text-warning">
                                <%=StringUtils.toStar(review.getStar()) %>
                                <!-- 
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                 -->
                            </span>	
                            <span class="ms-2 fw-bold"><%=review.getTitle() %></span>
                        </div>
                        <small class="text-muted"><%=StringUtils.detailDate(review.getCreatedDate()) %></small>
                    </div>
                    <p class="mb-1"><%=review.getContent() %></p>
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">작성자: <%=review.getWriter().getName() %></small>
                        <div>
                            <button class="btn btn-sm btn-outline-secondary me-2">
                                <i class="far fa-thumbs-up"></i> <%=review.getLikes() %>
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="far fa-comment"></i> 답글
                            </button>
                            <a href="review-delete.jsp?bno=<%=book.getNo() %>&rno=<%=review.getNo() %>" class="btn btn-outline-danger btn-sm">삭제</a>
                        </div>
                    </div>
                </div>
<%	
	}
%>

<%
	if (totalRows > bookReviews.size()) {
%>
                <div class="text-center mt-4" id="div-more-review">
                    <button id="btn-load-more-reviews" class="btn btn-outline-primary" data-next-page="<%=pagination.getNextPage() %>">더 많은 리뷰 보기</button>
                </div>
<%
	}
%>
            </div>
        </div>

        <!-- Related Books -->
        <div class="mt-5">
            <h3>관련 도서</h3>
            <div class="row">
                <div class="col-md-3">
                    <div class="card">
                        <img src="https://via.placeholder.com/150x200" class="card-img-top" alt="관련 도서 1">
                        <div class="card-body">
                            <h5 class="card-title">관련 도서 1</h5>
                            <p class="card-text">저자명</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card">
                        <img src="https://via.placeholder.com/150x200" class="card-img-top" alt="관련 도서 2">
                        <div class="card-body">
                            <h5 class="card-title">관련 도서 2</h5>
                            <p class="card-text">저자명</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card">
                        <img src="https://via.placeholder.com/150x200" class="card-img-top" alt="관련 도서 3">
                        <div class="card-body">
                            <h5 class="card-title">관련 도서 3</h5>
                            <p class="card-text">저자명</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card">
                        <img src="https://via.placeholder.com/150x200" class="card-img-top" alt="관련 도서 4">
                        <div class="card-body">
                            <h5 class="card-title">관련 도서 4</h5>
                            <p class="card-text">저자명</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer mt-5">
        <div class="container">
            <div class="text-center">
                <small class="text-muted">&copy; 2024 우도도서관. All rights reserved.</small>
            </div>
        </div>
    </footer>

   <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
    
    	// 폼 제출 시 유효성 검사
	    $("#reviewForm").submit(function() {
			if ($("#reviewTitle").val() == "") {
				alert("제목을 입력해주세요.");
				$("#reviewTitle").focus();
				return false;
			}
			
			if ($("#reviewContent").val() == "") {
				alert("내용을 입력해주세요.");
				$("#reviewContent").focus();
				return false;
			}
	
			return true;
	    });
<%
	if ("add".equals(complete)) {
%>
    	alert('리뷰가 등록되었습니다.');
<%
	}
%>
    
<%
	if ("delete".equals(complete)) {
%>
    	alert('리뷰가 삭제되었습니다.');
<%
	}
%>
    
	    $("select[name='sort']").change (function() {
	    	$("#form-filter input[name=page]").val(1);
			$("#form-filter").trigger("submit");
	    });
   
		document.getElementById('librarySelect').addEventListener('change', function() {
			const borrowButton = document.getElementById('borrowButton');
		    const selectedOption = this.options[this.selectedIndex];
		    const hasStock = selectedOption.text.includes('재고: 0권') === false;
		    borrowButton.disabled = !this.value || !hasStock;
		});
		

		
		// 별점 표시
		function toStar(star) {
			if (star < 1) {
    			return "☆☆☆☆☆";
    		} else if (star < 2) {
    			return "★☆☆☆☆";
    		} else if (star < 3) {
    			return "★★☆☆☆";
    		} else if (star < 4) {
    			return "★★★☆☆";
    		} else if (star < 5) {
    			return "★★★★☆";
    		} else {
    			return "★★★★★";
    		}
		}
		
		let readRows = <%=bookReviews.size() %>;
		
		// 리뷰 더보기 버튼으로 비동기 통신
		$("#btn-load-more-reviews").click(function() {
			const bookNo = $("input[name=bno]").val();
			let page = parseInt($("input[name=nextPage]").val());
			const totalRows = $("input[name=totalRows]").val();
			const sort = $("select[name=sort]").val();
			
			console.log("bookNo: ", bookNo);
			console.log("page: ", page);
			console.log("totalRows: ", totalRows);
			

			$.ajax({
				method: "get",
				url: "review-more.jsp",
				dataType: "json",
				data: {
					bookNo,
					page,
					totalRows,
					sort
				},
				success: function(reviewArr) {
					
					readRows += reviewArr.length;
					if (readRows >= totalRows) {
						$("#div-more-review").hide();
					}
					
					for (let review of reviewArr) {
						const content = `
							<div class="review-item border-bottom py-3">
			                    <div class="d-flex justify-content-between align-items-center mb-2">
			                        <div>
			                            <span class="text-warning">
			                            	\${toStar(review.star)}
			                            </span>	
			                            <span class="ms-2 fw-bold">\${review.title}</span>
			                        </div>
			                        <small class="text-muted">
			                        	\${review.createdDate}
			                        </small>
			                    </div>
			                    <p class="mb-1">\${review.content}</p>
			                    <div class="d-flex justify-content-between align-items-center">
			                        <small class="text-muted">작성자: \${review.writer.name}</small>
			                        <div>
			                            <button class="btn btn-sm btn-outline-secondary me-2">
			                                <i class="far fa-thumbs-up"></i> \${review.likes}
			                            </button>
			                            <button class="btn btn-sm btn-outline-secondary">
			                                <i class="far fa-comment"></i> 답글
			                            </button>
			                            <a href="review-delete.jsp?bno=\${bookNo}&rno=\${review.no}" class="btn btn-outline-danger btn-sm">삭제</a>
			                        </div>
			                    </div>
			                </div>
						`;
						
						$("#review-list").append(content);
					}
					 // 페이지 값 증가시키기
		            page++;
		            $("input[name=nextPage]").val(page);
		            
		            
		         	// "더보기" 버튼 위치 조정
		            $("#div-more-review").insertAfter("#review-list");
				}
			});
		});
    </script>
</body>
</html> 
					