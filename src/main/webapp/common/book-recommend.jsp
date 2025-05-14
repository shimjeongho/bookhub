<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.RecommendBooksMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 맵퍼
	RecommendBooksMapper recommendBooksMapper = MybatisUtils.getMapper(RecommendBooksMapper.class);

	// 로그인 유저 아이디
	String loginedUserId = (String)session.getAttribute("LOGINED_USER_ID");
	
	// 로그인 유저 대여 목록 개수 가져오기(로그인 상태가 아닐 시 0)
	int userLoanCnt = 0;
	
	if (loginedUserId != null) {
		userLoanCnt = recommendBooksMapper.getTotalLoanHistoryRows(loginedUserId);
	}
	
	// 맞춤 도서 가져오기
	List<Book> recommendBooks = recommendBooksMapper.getRecommendBooksByUserId(loginedUserId, userLoanCnt);

	if (!recommendBooks.isEmpty()) {
%>
		<!-- recommend -->
		<section class="fly_menu_wrapper sps" id="fly_wing_banner">
			<div id="fly-menu-toggle">
				<i class="bi bi-chevron-right"></i>
			</div>

		    <div class="fly_menu_inner">
		        <div class="fly_event_area">
		        	<p class="recommend_title">추천 도서</p>
		        
		            <div class="fly_event_banner rounded-1 overflow-hidden">
		                <div class="swiper-container swiper1">
		                    <ul class="swiper-wrapper">
<%
		for (Book recommendBook : recommendBooks) {
%>
								<li class="swiper-slide">
		                            <a href="/bookhub/book/detail.jsp?bno=<%=recommendBook.getNo() %>" class="d-flex flex-column align-items-center gap-2">
		                                <span class="recommend_book_thumb">
		                                	<img src="<%=recommendBook.getCoverImagePath() %>" alt="이벤트 1" class="img-fluid rounded-1">
		                                </span>
		                                <span class="small text-muted book_title"><%=recommendBook.getTitle() %></span>
		                                <span class="btn btn-sm btn-outline-primary">보러가기</span>
		                            </a>
		                        </li>
<%
		}
%>
		                    </ul>
		                </div>
		                <div class="swiper-button-next swiper1-next"></div>
		    			<div class="swiper-button-prev swiper1-prev"></div>
		    			<div class="swiper-pagination swiper1-pagination"></div>
		            </div>
		        </div>
		    </div>
		</section>
	
		<!-- Swiper JS -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
		<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
		<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
		<script>
			$(document).ready(function() {
				const swiper1 = new Swiper(".swiper1", {
					loop: true,
					spaceBetween: 10,
					pagination: {
			            el: '.swiper1-pagination',
			            type: 'fraction',
			            clickable: true
			        },
			        navigation: {
			            nextEl: '.swiper1-next',
			            prevEl: '.swiper1-prev',
			        },
			        /* autoplay: {
				        delay: 3000,
				        disableOnInteraction: false,
			    	} */
				});
				
				/* const swiper2 = new Swiper(".swiper2", {
					loop: true,
					spaceBetween: 10,
					pagination: {
			            el: '.swiper2-pagination',
			            type: 'fraction',
			            clickable: true
			        },
			        navigation: {
			            nextEl: '.swiper2-next',
			            prevEl: '.swiper2-prev',
			        },
				}); */
				
				// 추천 도서 fiexd 토글 버튼
				$("#fly-menu-toggle").click(function() {
					$("#fly_wing_banner").toggleClass("hidden");
					
					const $icon = $(this).find("i");
	
					if ($icon.hasClass("bi-chevron-right")) {
						$icon.removeClass("bi-chevron-right").addClass("bi-chevron-left");
				    } else {
					    $icon.removeClass("bi-chevron-left").addClass("bi-chevron-right");
				    }
				});
			});
			
		</script>
<%
	}
%>