<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 윙배너 -->
<section class="fly_menu_wrapper sps" id="fly_wing_banner">
    <div class="fly_menu_inner">
        <div class="fly_event_area">
            <div class="fly_event_banner">
                <div class="swiper-container swiper1">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <a href="#">
                                <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=300&h=200&fit=crop" alt="이벤트 1" class="img-fluid">
                                <p>추천도서1</p>
                            </a>
                        </li>
                        <li class="swiper-slide">
                            <a href="#">
                                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=200&fit=crop" alt="이벤트 2" class="img-fluid">
                                <p>추천도서2</p>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="swiper_control_box">
                    <button type="button" class="swiper-button-prev swiper1-prev">
                        <i class="fas fa-chevron-left"></i>
                        <span class="visually-hidden">이전</span>
                    </button>
                    <div class="swiper-pagination swiper1-pagination"></div>
                    <button type="button" class="swiper-button-next swiper1-next">
                        <i class="fas fa-chevron-right"></i>
                        <span class="visually-hidden">다음</span>
                    </button>
                </div>
            </div>
        </div>

        <div class="fly_event_area">
            <div class="fly_event_banner">
                <div class="swiper-container swiper2">
                    <ul class="swiper-wrapper">
                        <li class="swiper-slide">
                            <a href="#">
                                <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=300&h=200&fit=crop" alt="이벤트 1" class="img-fluid">
                                <p>추천도서1</p>
                            </a>
                        </li>
                        <li class="swiper-slide">
                            <a href="#">
                                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=200&fit=crop" alt="이벤트 2" class="img-fluid">
                                <p>추천도서2</p>
                            </a>
                        </li>
                        <li class="swiper-slide">
                            <a href="#">
                                <img src="https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=300&h=200&fit=crop" alt="이벤트 3" class="img-fluid">
                                <p>추천도서3</p>
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="swiper_control_box">
                    <button type="button" class="swiper-button-prev swiper2-prev">
                        <i class="fas fa-chevron-left"></i>
                        <span class="visually-hidden">이전</span>
                    </button>
                    <div class="swiper-pagination swiper2-pagination"></div>
                    <button type="button" class="swiper-button-next swiper2-next">
                        <i class="fas fa-chevron-right"></i>
                        <span class="visually-hidden">다음</span>
                    </button>
                </div>
            </div>
        </div>

        <div class="fly_link_box">
            <a id="wing_coupon" href="javascript:void(0)" class="fly_menu_link">
                <i class="fas fa-ticket-alt">더 보기</i> 
            </a>
        </div>
    </div>
</section>
<!-- // 윙배너 -->

<style>
.fly_menu_wrapper {
    position: fixed;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    z-index: 1000;
    width: 120px;
    background: #fff;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
    border-radius: 8px 0 0 8px;
    transition: all 0.3s ease;
}

.fly_menu_wrapper:hover {
    transform: translateY(-50%) translateX(-5px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.15);
}

.fly_menu_inner {
    padding: 15px;
}

.fly_menu_banner {
    display: block;
    margin-bottom: 15px;
    border-radius: 4px;
    overflow: hidden;
}

.fly_menu_banner img {
    width: 100%;
    transition: all 0.3s ease;
}

.fly_menu_banner:hover img {
    transform: scale(1.05);
}

.fly_event_area {
    margin-bottom: 15px;
}

.fly_menu_link {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 8px;
    color: #333;
    text-decoration: none;
    border-radius: 4px;
    margin-bottom: 5px;
    transition: all 0.3s ease;
    background-color: #f8f9fa;
    font-weight: 500;
}

.fly_menu_link:hover {
    background-color: #3498db;
    color: white;
    transform: translateX(-3px);
}

.fly_menu_link i {
    margin-right: 5px;
}

.fly_event_banner {
    margin-top: 10px;
    border-radius: 4px;
    overflow: hidden;
    position: relative;
}

.swiper-container {
    width: 100%;
    height: auto; 
}

.swiper-slide {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.swiper-slide img {
    width: 100%;
    height: auto;
    object-fit: cover;
    border-radius: 4px;
}

.swiper-slide p {
    margin: 5px 0 0;
    font-size: 12px;
    text-align: center;
}

.swiper_control_box {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 10px;
}

.swiper-button-prev,
.swiper-button-next {
    width: 20px;
    height: 20px;
    background: rgba(255, 255, 255, 0.8);
    border: none;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    z-index: 10;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.swiper-button-prev {
    left: 5px;
}

.swiper-button-next {
    right: 5px;
}

.swiper-button-prev:hover,
.swiper-button-next:hover {
    background: #3498db;
    color: white;
}

.swiper-pagination {
    margin: 0 10px;
}

.fly_link_box {
    border-top: 1px solid #eee;
    padding-top: 15px;
}

@media (max-width: 768px) {
    .fly_menu_wrapper {
        display: none;
    }
}
</style>

<!-- Swiper JS -->
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // First Swiper
    new Swiper('.swiper1', {
        loop: true,
        pagination: {
            el: '.swiper1-pagination',
            clickable: true
        },
        navigation: {
            nextEl: '.swiper1-next',
            prevEl: '.swiper1-prev',
        },
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        }
    });

    // Second Swiper
    new Swiper('.swiper2', {
        loop: true,
        pagination: {
            el: '.swiper2-pagination',
            clickable: true
        },
        navigation: {
            nextEl: '.swiper2-next',
            prevEl: '.swiper2-prev',
        },
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        }
    });
});
</script>

					