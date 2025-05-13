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
	String userId = (String)session.getAttribute("LOGINED_USER_ID");
	
	// 로그인 유저 대여 목록 개수 가져오기(로그인 상태가 아닐 시 0)
	int userLoanCnt = 0;
	
	if (userId != null) {
		userLoanCnt = recommendBooksMapper.getTotalLoanHistoryRows(userId);
	}
	
	// 맞춤 도서 가져오기
	List<Book> recommendBooks = recommendBooksMapper.getRecommendBooksByUserId(userId, userLoanCnt);

	if (!recommendBooks.isEmpty()) {
%>
		<!-- recommend -->
		<section class="fly_menu_wrapper sps" id="fly_wing_banner">
		    <div class="fly_menu_inner">
		        <div class="fly_event_area">
		        	<p class="recommend_title">추천 도서</p>
		        
		            <div class="fly_event_banner rounded-1 overflow-hidden">
		                <div class="swiper-container swiper1">
		                    <ul class="swiper-wrapper">
<%
		for (Book book : recommendBooks) {
%>
								<li class="swiper-slide">
		                            <a href="/bookhub/book/detail.jsp?bno=<%=book.getNo() %>" class="d-flex flex-column align-items-center gap-2">
		                                <span class="recommend_book_thumb">
		                                	<img src="<%=book.getCoverImagePath() %>" alt="이벤트 1" class="img-fluid rounded-1">
		                                </span>
		                                <span class="small text-muted book_title"><%=book.getTitle() %></span>
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
		<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
		<script>
			document.addEventListener('DOMContentLoaded', function() {
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
			});
		</script>
<%
	}
%>