<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자료 상세 - 우도도서관</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="../css/styles.css" rel="stylesheet">
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
            <div class="col-md-4">
                <img src="https://via.placeholder.com/300x400" alt="책 표지" class="img-fluid book-cover">
            </div>
            
            <!-- Book Information -->
            <div class="col-md-8">
                <div class="book-info">
                    <h1 class="book-title">책 제목이 들어갈 곳</h1>
                    <div class="book-meta">
                        <p><strong>저자:</strong> 저자명</p>
                        <p><strong>출판사:</strong> 출판사명</p>
                        <p><strong>출판년도:</strong> 2024</p>
                        <p><strong>ISBN:</strong> 978-89-1234-5678-9</p>
                        <p><strong>분류:</strong> 문학 > 소설</p>
                        <p class="d-flex align-items-center">
                            <strong class="me-2">평균 평점:</strong>
                            <span class="text-warning me-2">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </span>
                            <span class="text-muted">(4.5 / 128명)</span>
                        </p>
                    </div>
                    
                    <div class="availability">
                        <span class="badge bg-success availability-badge">대출 가능</span>
                    </div>
                    
                    <div class="action-buttons">
                        <div class="mb-3">
                            <select class="form-select" id="librarySelect">
                                <option value="">도서관을 선택하세요</option>
                                <option value="central">우도중앙도서관 (재고: 3권)</option>
                                <option value="west">우도서부도서관 (재고: 1권)</option>
                                <option value="east">우도동부도서관 (재고: 2권)</option>
                                <option value="south">우도남부도서관 (재고: 0권)</option>
                            </select>
                        </div>
                        <button class="btn btn-primary me-2" id="borrowButton" disabled>
                        	<a href="loan.jsp?bno=107&lno=2">
                            <i class="fas fa-book"></i> 대여하기
                            </a>
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
            <p>이곳에 도서에 대한 상세한 설명이 들어갑니다. 책의 내용, 저자의 의도, 독자들에게 가져다 주는 가치 등이 포함될 수 있습니다.</p>
            
            <h4 class="mt-4">목차</h4>
            <div class="table-of-contents">
                <ol>
                    <li>1장 - 시작</li>
                    <li>2장 - 전개</li>
                    <li>3장 - 위기</li>
                    <li>4장 - 절정</li>
                    <li>5장 - 결말</li>
                </ol>
            </div>
        </div>

        <!-- Review Section -->
        <div class="review-section mt-5">
            <h3>도서 리뷰</h3>
            
            <!-- Review Summary -->
            <div class="review-summary mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <h2 class="mb-0">4.5</h2>
                        <div class="text-warning">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </div>
                        <small class="text-muted">총 128개의 리뷰</small>
                    </div>
                    <div class="ms-3">
                        <div class="d-flex align-items-center mb-1">
                            <small class="me-2">5점</small>
                            <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
                                <div class="progress-bar bg-warning" style="width: 75%"></div>
                            </div>
                            <small class="ms-2">75%</small>
                        </div>
                        <div class="d-flex align-items-center mb-1">
                            <small class="me-2">4점</small>
                            <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
                                <div class="progress-bar bg-warning" style="width: 15%"></div>
                            </div>
                            <small class="ms-2">15%</small>
                        </div>
                        <div class="d-flex align-items-center mb-1">
                            <small class="me-2">3점</small>
                            <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
                                <div class="progress-bar bg-warning" style="width: 5%"></div>
                            </div>
                            <small class="ms-2">5%</small>
                        </div>
                        <div class="d-flex align-items-center mb-1">
                            <small class="me-2">2점</small>
                            <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
                                <div class="progress-bar bg-warning" style="width: 3%"></div>
                            </div>
                            <small class="ms-2">3%</small>
                        </div>
                        <div class="d-flex align-items-center">
                            <small class="me-2">1점</small>
                            <div class="progress flex-grow-1" style="width: 100px; height: 8px;">
                                <div class="progress-bar bg-warning" style="width: 2%"></div>
                            </div>
                            <small class="ms-2">2%</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Write Review -->
            <div class="write-review mb-4">
                <h4>리뷰 작성하기</h4>
                <form id="reviewForm">
                    <div class="mb-3">
                        <label class="form-label">평점</label>
                        <div class="rating">
                            <input type="radio" name="rating" value="5" id="5"><label for="5"><i class="fas fa-star"></i></label>
                            <input type="radio" name="rating" value="4" id="4"><label for="4"><i class="fas fa-star"></i></label>
                            <input type="radio" name="rating" value="3" id="3"><label for="3"><i class="fas fa-star"></i></label>
                            <input type="radio" name="rating" value="2" id="2"><label for="2"><i class="fas fa-star"></i></label>
                            <input type="radio" name="rating" value="1" id="1"><label for="1"><i class="fas fa-star"></i></label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="reviewTitle" class="form-label">제목</label>
                        <input type="text" class="form-control" id="reviewTitle" placeholder="리뷰 제목을 입력하세요">
                    </div>
                    <div class="mb-3">
                        <label for="reviewContent" class="form-label">내용</label>
                        <textarea class="form-control" id="reviewContent" rows="4" placeholder="이 책에 대한 의견을 자유롭게 작성해주세요"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">리뷰 등록</button>
                </form>
            </div>

            <!-- Review List -->
            <div class="review-list">
                <h4>최신 리뷰</h4>
                <div class="review-item border-bottom py-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div>
                            <span class="text-warning">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </span>
                            <span class="ms-2 fw-bold">정말 좋은 책이에요!</span>
                        </div>
                        <small class="text-muted">2024.03.15</small>
                    </div>
                    <p class="mb-1">이 책은 정말 읽을 가치가 있는 책입니다. 특히 중반부의 전개가 매우 흥미롭고...</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">작성자: 김도서</small>
                        <div>
                            <button class="btn btn-sm btn-outline-secondary me-2">
                                <i class="far fa-thumbs-up"></i> 15
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="far fa-comment"></i> 답글
                            </button>
                        </div>
                    </div>
                </div>

                <div class="review-item border-bottom py-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div>
                            <span class="text-warning">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                            </span>
                            <span class="ms-2 fw-bold">흥미로운 내용</span>
                        </div>
                        <small class="text-muted">2024.03.14</small>
                    </div>
                    <p class="mb-1">전반적으로 만족스러운 책이었습니다. 다만 마지막 부분이 조금 아쉬웠어요.</p>
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">작성자: 이독자</small>
                        <div>
                            <button class="btn btn-sm btn-outline-secondary me-2">
                                <i class="far fa-thumbs-up"></i> 8
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="far fa-comment"></i> 답글
                            </button>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button class="btn btn-outline-primary">더 많은 리뷰 보기</button>
                </div>
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
    <script>
    // Library selection and button activation
    document.getElementById('librarySelect').addEventListener('change', function() {
        const borrowButton = document.getElementById('borrowButton');
        const selectedOption = this.options[this.selectedIndex];
        const hasStock = selectedOption.text.includes('재고: 0권') === false;
        borrowButton.disabled = !this.value || !hasStock;
    });

    // Review form submission
    document.getElementById('reviewForm').addEventListener('submit', function(event) {
        event.preventDefault();
        
        const rating = document.querySelector('input[name="rating"]:checked');
        const title = document.getElementById('reviewTitle').value;
        const content = document.getElementById('reviewContent').value;
        
        if (!rating) {
            alert('평점을 선택해주세요.');
            return;
        }
        
        if (!title.trim()) {
            alert('제목을 입력해주세요.');
            return;
        }
        
        if (!content.trim()) {
            alert('내용을 입력해주세요.');
            return;
        }
        
        // Here you would typically send the review to your server
        alert('리뷰가 등록되었습니다.');
        this.reset();
    });
    </script>
</body>
</html> 