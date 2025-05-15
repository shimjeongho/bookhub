<%@page import="kr.co.bookhub.mapper.BookWishListMapper"%>
<%@page import="kr.co.bookhub.mapper.StockMapper"%>
<%@page import="kr.co.bookhub.vo.Stock"%>
<%@page import="kr.co.bookhub.mapper.LibraryMapper"%>
<%@page import="kr.co.bookhub.vo.Library"%>
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
	// 로그인 유저 아이디
	String userId = (String) session.getAttribute("LOGINED_USER_ID");
	
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
	condition.put("userId", userId);
	
	// 리뷰 등록후 완료 알림
	String complete = (String) session.getAttribute("complete");
	session.removeAttribute("complete");
	
	// 리뷰 삭제후 완료 알림
	String delete = (String) session.getAttribute("delete");
	session.removeAttribute("complete");
	
	// 구현객체 가져오기
	BookMapper bookMapper = MybatisUtils.getMapper(BookMapper.class);
	BookReviewMapper bookReviewMapper = MybatisUtils.getMapper(BookReviewMapper.class);
	LibraryMapper libraryMapper = MybatisUtils.getMapper(LibraryMapper.class);
	StockMapper stockMapper = MybatisUtils.getMapper(StockMapper.class);
	BookWishListMapper bookWishListMapper = MybatisUtils.getMapper(BookWishListMapper.class);
	
	// 해당 도서의 찜 여부
	int isBookWish = bookWishListMapper.isBookWish(condition);
	
	// 책 정보 조회
	Book book = bookMapper.getBookByNo(bookNo);
	// 도서 번호를 이용하여 도서관 책 재고 조회
	List<Stock> stocks = libraryMapper.getLibraryStocksByBookNo(bookNo);
	// 특정 도서 번호를 전달받아 모든 도서관 재고를 체크한다
	int availableCount = stockMapper.getBookAvailability(bookNo);
	// library getter
	Library lib = new Library();
	
	
	// 총 리뷰 개수 조회
	int totalRows = bookReviewMapper.getTotalRows(bookNo);
	// 페이지네이션 객체를 생성
	Pagination pagination = new Pagination(pageNo, totalRows);
	// 필터링 조건에 offset과 rows를 추가
	condition.put("offset", pagination.getOffset());
	condition.put("rows", pagination.getRows());
	// 필터링 조건에 맞는 리뷰목록 조회
	List<BookReview> bookReviews = bookReviewMapper.getBookReviewsByBookNo(condition);
	// 전체 리뷰 조회
    List<BookReview> bookReviewsAllList = bookReviewMapper.getAllBookReviewsByBookNo(condition);
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
    <%@ include file="../common/nav.jsp" %>	
    
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
<%
	if (availableCount > 0) {
%>                    
                    <div class="availability">
                        <span class="badge bg-success availability-badge">대출 가능</span>
                    </div>
<%
	} else {
%>
                    <div class="availability">
   						 <span class="badge bg-danger availability-badge">대출 불가능</span>
					</div>
<%
	}
%>                    
                    <div class="action-buttons">
                        <div class="mb-3">
                            <select class="form-select" id="librarySelect" name="libNo" data-book-no="<%=bookNo%>">
                                <option value="" selected="selected" disabled="disabled">도서관을 선택하세요</option>
<%
	for  (Stock stock : stocks) {
%>
                                <option value="<%=stock.getLibrary().getNo() %>" <%=stock.getStock() == 0 ? "disabled" : "" %>><%=stock.getLibrary().getName() %> (재고: <%=stock.getStock() %>권)</option>
<%
	}
%>
                            </select>
                        </div>
<%
	if (userId != null) {
%>                        
                        <a href="bookhub/loan/loan.jsp?bno=<%=book.getNo() %>&lno=<%=lib.getNo() %>" class="btn btn-primary me-2 disabled" id="borrowButton" >
                            <i class="fas fa-book"></i> 대여하기
                        </a>
<%
	} else {
%>
						<button " class="btn btn-primary me-2 disabled">
                            <i class="fas fa-book"></i> 대여하기
						</button>
<%
	}
%>                       
<%
	if (userId != null) {
%>
						<button 
                        	id="wishlist-btn" 
                        	class="btn <%=isBookWish == 1 ? "btn-danger" : "btn-outline-secondary"  %>"
                        	data-book-no="<%=bookNo %>"
                        	data-book-wish="<%=isBookWish%>">
                            <i class="fas fa-heart"></i> <span id="wishlistText">찜하기</span>
                        </button>
<%
	} else {
%>
						<button class="btn btn-outline-secondary disabled">
                            <i class="fas fa-heart"></i> <span id="wishlistText">찜하기</span>
						</button>
<%
	}
%>
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
   

    for (BookReview review : bookReviewsAllList) {
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
<%
	if (userId != null) {
%>
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
<%
	}
%>
<%
	int reviewCount = book.getReviewCount();                      		
%>
<%
	if (reviewCount > 0) {
%>
            <!-- Review List -->
            <div class="review-list" id="review-list">
                <h4> 리뷰 (<%=StringUtils.commaWithNumber(book.getReviewCount()) %> 개)</h4>
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
	}
%>			      
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
                            <button id="like-button-<%=review.getNo()%>" 
					        	class="btn btn-sm btn-outline-secondary me-2 like-button"
					        	data-review-no="<%=review.getNo()%>">
					    		<i class="far fa-thumbs-up"></i> 
					    		<span id="like-count-<%=review.getNo()%>"><%=review.getLikes() %></span>
							</button>
							<%
								if (review.getWriter().getId().equals(loggedInUserId)) {
							%>
                            	<a href="review-delete.jsp?bno=<%=book.getNo() %>&rno=<%=review.getNo() %>" 
                            	class="btn btn-outline-danger btn-sm delete-btn"
                            	data-writer-id="<%=review.getWriter().getId() %>"
                            	data-logged-in-id="<%=userId%>">삭제</a>
							<%		
								} else {
							%>
								<button class="btn btn-secondary btn-sm" disabled>삭제</button>
							<%
								}
							%>
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
    </div>
    
    <%@ include file="../common/book-recommend.jsp" %>

    <%@ include file="../common/footer.jsp" %>

   <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
    
    	$("#review-list").on('click', '.like-button', function() {
    		const reviewNo = $(this).attr("data-review-no");
    		const isLiked = $(this).hasClass("liked");
    		
    		$.ajax({
    			method: "get",
    			url: "like.jsp",
    			dataType: "json",
    			data: {
    				reviewNo,
    				action: isLiked ? "decrease" : "increase"
    			},
    			success: function(response) {
   				// 좋아요 개수 업데이트
	   	            $(`#like-count-\${reviewNo}`).text(response.updatedLikes);
	
	   	            if (isLiked) {
	   	                $(`#like-button-\${reviewNo}`).removeClass("liked");
	   	            } else {
	   	                $(`#like-button-\${reviewNo}`).addClass("liked");
	   	            }
	   	        },
	   	        error: function(xhr, status, error) {
	   	            alert("오류가 발생했습니다.");
	    	        }
    		})
    	})
    
    	// 찜 하기 버튼으로 비동기 통신
    	$("#wishlist-btn").click(function() {
    		const $btn = $(this);
    		const bookNo = $(this).attr("data-book-no");
    		const isBookWish= $(this).attr("data-book-wish");
    		
    		$.ajax({
    			method: "get",
    			url: "wishlist.jsp",
    			datatype: "text",
    			data: {
    				bookNo: bookNo,
    				isBookWish: isBookWish
    			},
    			success: function(response) {
    				if(response == "0") {
    					$btn.removeClass("btn-danger").addClass("btn-outline-secondary");
    					$btn.attr("data-book-wish", "0");
    				} else if (response == "1") {
    					$btn.removeClass("btn-outline-secondary").addClass("btn-danger");
    					$btn.attr("data-book-wish", "1");
    				}
				}
    		});
    		
		})
    
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
    	
 // 리뷰 등록/삭제 후 알림창
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
    
    	// 정렬 기능
	    $("select[name='sort']").change (function() {
	    	$("#form-filter input[name=page]").val(1);
			$("#form-filter").trigger("submit");
	    });
	    
    	// 도서관 선택
	    $("#librarySelect").change(function() {
	    	let libNo = $(this).val();
	    	let bookNo = $(this).attr("data-book-no");
	    	
	    	$("#borrowButton").attr("href", `/bookhub/loan/loan.jsp?bno=\${bookNo}&lno=\${libNo}`)
	    					  .removeClass("disabled")
	    	
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
						let content = `
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
				                        <button id="like-button-\${review.no}" 
								        	class="btn btn-sm btn-outline-secondary me-2 like-button"
								        	data-review-no="\${review.no}">
								    		<i class="far fa-thumbs-up"></i> 
								    		<span id="like-count-\${review.no}">\${review.likes}</span>
										</button>`
						;
						
						if (review.writer.id == '<%=userId%>') {							
							content += `<a href="review-delete.jsp?bno=\${bookNo}&rno=\${review.no}" class="btn btn-outline-danger btn-sm">삭제</a>`
						} else {
							content += `<button href="review-delete.jsp?bno=\${bookNo}&rno=\${review.no}" class="btn btn-secondary btn-sm" disabled>삭제</b>`
						}
						 
						content += `
			                        </div>
			                    </div>
			                </div>
						`;
						
						$("#review-list").append(content);
					}
		            
		            
		         	// "더보기" 버튼 위치 조정
		            $("#div-more-review").insertAfter("#review-list");
				}
			});
		});
    </script>
</body>
</html> 
					