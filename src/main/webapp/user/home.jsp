<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우도도서관</title>
    <!-- Google Fonts - Noto Sans KR -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <%@ include file="../common/nav.jsp" %>

    <!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 mb-4">우도도서관에 오신 것을 환영합니다</h1>
            <p class="lead mb-4">지식과 문화가 함께하는 공간</p>
            <a href="#" class="btn btn-light btn-lg">자료검색</a>
        </div>
    </section>

    <!-- Quick Links -->
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="service-card text-center">
                        <i class="fas fa-book fa-3x mb-3 text-primary"></i>
                        <h4>자료검색</h4>
                        <p>도서관 소장자료 검색</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="service-card text-center">
                        <i class="fas fa-calendar-alt fa-3x mb-3 text-primary"></i>
                        <h4>문화행사</h4>
                        <p>다양한 문화행사 안내</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="service-card text-center">
                        <i class="fas fa-info-circle fa-3x mb-3 text-primary"></i>
                        <h4>이용안내</h4>
                        <p>도서관 이용 방법</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="service-card text-center">
                        <i class="fas fa-building fa-3x mb-3 text-primary"></i>
                        <h4>도서관소개</h4>
                        <p>우도도서관 소개</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- News Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-4">도서관 소식</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="card news-card">
                        <img src="https://via.placeholder.com/400x200" class="card-img-top" alt="뉴스 이미지">
                        <div class="card-body">
                            <h5 class="card-title">2024년 봄 독서문화 프로그램</h5>
                            <p class="card-text">다양한 독서문화 프로그램이 시작됩니다.</p>
                            <a href="#" class="btn btn-outline-primary">자세히 보기</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card news-card">
                        <img src="https://via.placeholder.com/400x200" class="card-img-top" alt="뉴스 이미지">
                        <div class="card-body">
                            <h5 class="card-title">전자책 서비스 이용 안내</h5>
                            <p class="card-text">새로운 전자책 서비스 이용 방법을 안내합니다.</p>
                            <a href="#" class="btn btn-outline-primary">자세히 보기</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card news-card">
                        <img src="https://via.placeholder.com/400x200" class="card-img-top" alt="뉴스 이미지">
                        <div class="card-body">
                            <h5 class="card-title">도서관 휴관일 안내</h5>
                            <p class="card-text">2024년 도서관 휴관일을 안내합니다.</p>
                            <a href="#" class="btn btn-outline-primary">자세히 보기</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>우도도서관</h5>
                    <p>주소: 제주특별자치도 제주시 우도면 우도해안길 123</p>
                    <p>전화: 064-123-4567</p>
                </div>
                <div class="col-md-4">
                    <h5>이용시간</h5>
                    <p>평일: 09:00 - 18:00</p>
                    <p>주말: 09:00 - 17:00</p>
                </div>
                <div class="col-md-4">
                    <h5>바로가기</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-white">자료검색</a></li>
                        <li><a href="#" class="text-white">이용안내</a></li>
                        <li><a href="#" class="text-white">문화행사</a></li>
                    </ul>
                </div>
            </div>
            <hr class="mt-4">
            <div class="text-center">
                <small>&copy; 2024 우도도서관. All rights reserved.</small>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 