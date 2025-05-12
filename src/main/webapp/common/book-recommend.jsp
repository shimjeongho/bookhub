<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	
%>

<!-- recommend -->
<section class="fly_menu_wrapper sps" id="fly_wing_banner">
    <div class="fly_menu_inner">
        <div class="fly_event_area">
        	<p class="recommend_title">맞춤 도서</p>
        
            <div class="fly_event_banner rounded-1 overflow-hidden">
                <div class="swiper-container swiper1">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <a href="#" class="d-flex flex-column align-items-center">
                                <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=300&h=200&fit=crop" alt="이벤트 1" class="img-fluid rounded-1">
                                <span class="small text-muted book_title">추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1추천도서1</span>
                            </a>
                        </li>
                        <li class="swiper-slide">
                            <a href="#" class="d-flex flex-column align-items-center">
                                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=200&fit=crop" alt="이벤트 2" class="img-fluid rounded-1">
                                <span class="small text-muted book_title">추천도서2</span>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="swiper-button-next swiper1-prev"></div>
    			<div class="swiper-button-prev swiper1-next"></div>
    			<div class="swiper-pagination swiper1-pagination"></div>
            </div>
        </div>
        
        <div class="fly_event_area">
        	<p class="recommend_title">연관 도서</p>
        
            <div class="fly_event_banner rounded-1 overflow-hidden">
                <div class="swiper-container swiper2">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <a href="#" class="d-flex flex-column align-items-center">
                                <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=300&h=200&fit=crop" alt="이벤트 1" class="img-fluid rounded-1">
                                <span class="small text-muted book_title">추천도서1</span>
                            </a>
                        </li>
                        <li class="swiper-slide">
                            <a href="#" class="d-flex flex-column align-items-center">
                                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=200&fit=crop" alt="이벤트 2" class="img-fluid rounded-1">
                                <span class="small text-muted book_title">추천도서2</span>
                            </a>
                        </li>
                        <li class="swiper-slide">
                            <a href="#" class="d-flex flex-column align-items-center">
                                <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=300&h=200&fit=crop" alt="이벤트 3" class="img-fluid rounded-1">
                                <span class="small text-muted book_title">추천도서3</span>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="swiper-button-next swiper2-prev"></div>
    			<div class="swiper-button-prev swiper2-next"></div>
    			<div class="swiper-pagination swiper2-pagination"></div>
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
		
		const swiper2 = new Swiper(".swiper2", {
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
		});
	});
</script>