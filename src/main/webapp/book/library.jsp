<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="styles.css" rel="stylesheet">
    <title>도서관 목록</title>
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
                        <a class="nav-link" href="#">게시판</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="library.html">도서관소개</a>
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

    <!-- Page Header -->
    <section class="page-header">
        <div class="container">
            <h1>도서관 목록</h1>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="home.html">홈</a></li>
                    <li class="breadcrumb-item active" aria-current="page">도서관 목록</li>
                </ol>
            </nav>
        </div>
    </section>

    <!-- Library List -->
    <section class="py-5">
        <div class="container">
            <div class="row">
                <!-- Library Card Template -->
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card library-card h-100">
                        <img src="https://via.placeholder.com/300x200" class="card-img-top" alt="우도도서관">
                        <div class="card-body">
                            <h5 class="card-title">우도도서관</h5>
                            <p class="card-text">
                                <i class="fas fa-map-marker-alt text-primary"></i> 제주특별자치도 제주시 우도면 우도해안길 123<br>
                                <i class="fas fa-phone text-primary"></i> 064-123-4567<br>
                                <i class="fas fa-clock text-primary"></i> 평일 09:00 - 18:00
                            </p>
                            <a href="#" class="btn btn-primary stretched-link" 
                               data-lat="33.5138" 
                               data-lng="126.9514" 
                               onclick="showLibraryDetail(this)">상세정보</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Library Detail Modal -->
    <div class="modal fade" id="libraryDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">도서관 상세정보</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <img src="" id="modalLibraryImage" class="img-fluid rounded" alt="도서관 이미지">
                        </div>
                        <div class="col-md-6">
                            <h4 id="modalLibraryName"></h4>
                            <p>
                                <i class="fas fa-map-marker-alt text-primary"></i> <span id="modalLibraryAddress"></span><br>
                                <i class="fas fa-phone text-primary"></i> <span id="modalLibraryPhone"></span><br>
                                <i class="fas fa-clock text-primary"></i> <span id="modalLibraryHours"></span>
                            </p>
                            <div id="map" style="height: 300px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_MAPS_API_KEY"></script>
    
    <script>
        // 도서관 상세정보 모달 표시 함수
        function showLibraryDetail(element) {
            event.preventDefault();
            
            // 클릭된 도서관의 데이터 가져오기
            const lat = element.getAttribute('data-lat');
            const lng = element.getAttribute('data-lng');
            const card = element.closest('.card');
            const name = card.querySelector('.card-title').textContent;
            const address = card.querySelector('.fa-map-marker-alt').nextSibling.textContent.trim();
            const phone = card.querySelector('.fa-phone').nextSibling.textContent.trim();
            const hours = card.querySelector('.fa-clock').nextSibling.textContent.trim();
            const image = card.querySelector('.card-img-top').src;

            // 모달에 데이터 설정
            document.getElementById('modalLibraryName').textContent = name;
            document.getElementById('modalLibraryAddress').textContent = address;
            document.getElementById('modalLibraryPhone').textContent = phone;
            document.getElementById('modalLibraryHours').textContent = hours;
            document.getElementById('modalLibraryImage').src = image;

            // 카카오맵 표시
            const container = document.getElementById('map');
            const options = {
                center: new kakao.maps.LatLng(lat, lng),
                level: 3
            };
            const map = new kakao.maps.Map(container, options);
            
            // 마커 표시
            const markerPosition = new kakao.maps.LatLng(lat, lng);
            const marker = new kakao.maps.Marker({
                position: markerPosition
            });
            marker.setMap(map);

            // 모달 표시
            const modal = new bootstrap.Modal(document.getElementById('libraryDetailModal'));
            modal.show();
        }
    </script>
</body>
</html>
					