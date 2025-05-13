<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="kr.co.bookhub.vo.User" %>
<%@ page import="kr.co.bookhub.util.MybatisUtils" %>
<%@ page import="kr.co.bookhub.mapper.UserMapper" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 우도도서관</title>
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
<%
    String userId = (String)session.getAttribute("LOGINED_USER_ID");
    String userName = (String)session.getAttribute("LOGINED_USER_NAME");
    String userPhone = (String)session.getAttribute("LOGINED_USER_PHONE");

    if (userId == null) {
        // 로그인되지 않은 경우 처리
        response.sendRedirect("signin.jsp?error=auth");
        return;
    }
%>

    <!-- My Page Content -->
    <div class="mypage-container">
        <!-- Profile Section -->
        <div class="profile-section text-center">
            <h3><%= userName %>님</h3>
            <p class="text-muted"><%= userId %></p>
            <p>회원 등급: <span class="badge bg-primary">일반회원</span></p>
        </div>

        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab" aria-controls="profile" aria-selected="true">
                    <i class="fas fa-user me-1"></i> 내 정보 수정
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="rental-tab" data-bs-toggle="tab" data-bs-target="#rental" type="button" role="tab" aria-controls="rental" aria-selected="false">
                    <i class="fas fa-book me-1"></i> 대여 내역
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="return-tab" data-bs-toggle="tab" data-bs-target="#return" type="button" role="tab" aria-controls="return" aria-selected="false">
                    <i class="fas fa-undo me-1"></i> 반납 처리
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="wishlist-tab" data-bs-toggle="tab" data-bs-target="#wishlist" type="button" role="tab" aria-controls="wishlist" aria-selected="false">
                    <i class="fas fa-heart me-1"></i> 찜 목록
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="review-tab" data-bs-toggle="tab" data-bs-target="#review" type="button" role="tab" aria-controls="review" aria-selected="false">
                    <i class="fas fa-comment me-1"></i> 내 리뷰/게시글
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="delete-tab" data-bs-toggle="tab" data-bs-target="#delete" type="button" role="tab" aria-controls="delete" aria-selected="false">
                    <i class="fas fa-user-times me-1"></i> 회원탈퇴
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="myTabContent">
            <!-- Profile Tab -->
            <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                <h4 class="mb-4">내 정보 수정</h4>
                <form id="profile" action="update_profile.jsp" method="post">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label required">이름</label>
                            <input type="text" class="form-control" id="fullName" name="name" value="<%= userName %>" >
                            <div id="fullNameError" class="form-text mt-1"></div>
                        </div>
                 
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label required">휴대폰 번호</label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="<%= userPhone %>" >
                        <div id="phoneError" class="form-text mt-1"></div>
                    </div>


                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">현재 비밀번호</label>
                        <input type="password" class="form-control" name="password" id="currentPassword">
                        <div id="currentPasswordError" class="form-text mt-1"></div>
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input type="password" class="form-control" name="newPassword" id="newPassword">
                        <div id="newPasswordError" class="form-text mt-1"></div>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" class="form-control" name="confirmPassword" id="confirmPassword">
                        <div id="confirmPasswordError" class="form-text mt-1"></div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn btn-primary">정보 수정</button>
                    </div>
                </form>
            </div>
            
            <!-- Rental Tab -->
            <div class="tab-pane fade" id="rental" role="tabpanel" aria-labelledby="rental-tab">
                <h4 class="mb-4">대여 내역</h4>
                
                <!-- Active Rentals -->
                <h5 class="mb-3">현재 대여중</h5>
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-0">저자: 이영희 | 출판사: AI출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: 2024-03-15</p>
                            <p class="mb-0">반납일: 2024-03-29</p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-success status-badge">대여중</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-primary me-1">반납하기</button>
                            <button class="btn btn-sm btn-outline-primary">연장하기</button>
                        </div>
                    </div>
                </div>
                
                <!-- Past Rentals -->
                <h5 class="mt-4 mb-3">과거 대여 내역</h5>
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-0">저자: 이영희 | 출판사: AI출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: 2024-03-15</p>
                            <p class="mb-0">반납일: 2024-03-29</p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-secondary status-badge">반납완료</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-outline-secondary" disabled>반납완료</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Return Tab -->
            <div class="tab-pane fade" id="return" role="tabpanel" aria-labelledby="return-tab">
                <h4 class="mb-4">반납 처리</h4>
                
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i> 반납 예정일을 지난 도서가 있습니다. 빠른 반납 부탁드립니다.
                </div>
                
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-0">저자: 이영희 | 출판사: AI출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: 2024-03-15</p>
                            <p class="mb-0">반납일: 2024-03-29</p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-danger status-badge">연체중</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-primary me-1">반납하기</button>
                            <button class="btn btn-sm btn-outline-primary">연장하기</button>
                        </div>
                    </div>
                </div>
                
                <h5 class="mt-4 mb-3">반납 완료 내역</h5>
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-0">저자: 이영희 | 출판사: AI출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: 2024-03-15</p>
                            <p class="mb-0">반납일: 2024-03-29</p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-secondary status-badge">반납완료</span>
                        </div>
                        <div class="col-md-2">
                            <span class="text-muted">2024-03-29 반납</span>
                        </div>
                    </div>
                </div>
                
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>파이썬 데이터 분석</h5>
                            <p class="text-muted mb-0">저자: 박지민 | 출판사: 데이터출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0">대여일: 2024-02-01</p>
                            <p class="mb-0">반납일: 2024-02-15</p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-secondary status-badge">반납완료</span>
                        </div>
                        <div class="col-md-2">
                            <span class="text-muted">2024-02-15 반납</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Wishlist Tab -->
            <div class="tab-pane fade" id="wishlist" role="tabpanel" aria-labelledby="wishlist-tab">
                <h4 class="mb-4">찜 목록</h4>
                
                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-0">저자: 이영희 | 출판사: AI출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0"></p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-success status-badge">대출가능</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-primary">대출하기</button>
                        </div>
                    </div>
                </div>

                <div class="book-item">
                    <div class="row align-items-center">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-5">
                            <h5>파이썬 데이터 분석</h5>
                            <p class="text-muted mb-0">저자: 박지민 | 출판사: 데이터출판사</p>
                        </div>
                        <div class="col-md-2">
                            <p class="mb-0"></p>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-danger status-badge">대출중</span>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-outline-secondary" disabled>대출중</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Review Tab -->
            <div class="tab-pane fade" id="review" role="tabpanel" aria-labelledby="review-tab">
                <h4 class="mb-4">내 리뷰/게시글</h4>
                
                <!-- Reviews -->
                <h5 class="mb-3">도서 리뷰</h5>
                <div class="review-item">
                    <div class="row">
                        <div class="col-md-1">
                            <img src="https://via.placeholder.com/80x120" alt="책 표지" class="book-cover">
                        </div>
                        <div class="col-md-11">
                            <h5>실전 파이썬 머신러닝</h5>
                            <p class="text-muted mb-2">저자: 이영희 | 출판사: AI출판사</p>
                            <div class="mb-2">
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                            </div>
                            <p>머신러닝을 배우고 싶은 분들에게 추천합니다. 실습 예제가 많아 실제로 적용하기 좋습니다.</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">작성일: 2024-03-15</small>
                                <div>
                                    <button class="btn btn-sm btn-outline-primary me-1">수정</button>
                                    <button class="btn btn-sm btn-outline-danger">삭제</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Posts -->
                <h5 class="mt-4 mb-3">게시글</h5>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>제목</th>
                                <th>작성일</th>
                                <th>조회수</th>
                                <th>댓글수</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>도서관 이용 시간 변경 제안</td>
                                <td>2024-03-10</td>
                                <td>45</td>
                                <td>12</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1">수정</button>
                                    <button class="btn btn-sm btn-outline-danger">삭제</button>
                                </td>
                            </tr>
                            <tr>
                                <td>새로운 도서 구매 요청</td>
                                <td>2024-02-28</td>
                                <td>32</td>
                                <td>8</td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary me-1">수정</button>
                                    <button class="btn btn-sm btn-outline-danger">삭제</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Delete Account Tab -->
            <div class="tab-pane fade" id="delete" role="tabpanel" aria-labelledby="delete-tab">
                <h4 class="mb-4">회원 탈퇴</h4>
                
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i> 회원 탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.
                </div>
                
                <form>
                    <div class="mb-3">
                        <label for="deletePassword" class="form-label">비밀번호 확인</label>
                        <input type="password" class="form-control" id="deletePassword" required>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="confirmDelete" required>
                            <label class="form-check-label" for="confirmDelete">
                                회원 탈퇴에 동의합니다.
                            </label>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <button type="submit" class="btn btn-danger">회원 탈퇴</button>
                    </div>
                </form>
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
    
    <!-- Bootstrap Modal (업데이트 성공) -->
	<div class="modal fade" id="updateSuccessModal" tabindex="-1" aria-labelledby="updateSuccessModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="updateSuccessModalLabel">회원정보 수정완료</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body" id="updateSuccessModalMessage">
	                <!-- 에러 메시지가 여기에 표시됩니다. -->
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	            </div>
	        </div>
	    </div>
	</div>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    	$(document).ready(function() {
    		const $fullNameInput = $('#fullName');
    		const $fullNameError = $('#fullNameError');
    		const $phoneInput = $('#phone');
    		const $phoneError = $('#phoneError');
    		const $passwordInput = $('#currentPassword');
    		const $passwordError = $('#currentPasswordError');
    		const $newPasswordInput = $('#newPassword');
    		const $newPasswordError = $('#newPasswordError');
    		const $confirmPasswordInput = $('#confirmPassword');
    		const $confirmPasswordError = $('#confirmPasswordError');
    		
    		//bootstrap 모달객체 미리 생성
    		const updateSuccessModal = new bootstrap.Modal(document.getElementById('updateSuccessModal'));
    		const $updateSuccessModalMessage = $('#updateSuccessModalMessage');        
            const $updateSuccessModalLabel = $('#updateSuccessModalLabel');
    		
    		$('#profile').on('submit', function(event) {
    			event.preventDefault();
    			console.log('폼제출이 시도되었습니다');
    			
    			$fullNameInput.removeClass('is-invalid');
    			$fullNameError.text('').removeClass('text-danger');   			
    			$phoneInput.removeClass('is-invalid');
    			$phoneError.text('').removeClass('text-danger');   			
    			$passwordInput.removeClass('is-invalid');
    			$passwordError.text('').removeClass('text-danger');   			
    			$newPasswordInput.removeClass('is-invalid');
    			$newPasswordError.text('').removeClass('text-danger');   			
    			$confirmPasswordInput.removeClass('is-invalid');
    			$confirmPasswordError.text('').removeClass('text-danger');   			
    			
    			const fullNameValue = $fullNameInput.val().trim();
    			const phoneValue = $phoneInput.val();
    			const passwordValue = $passwordInput.val();
    			const newPasswordValue = $newPasswordInput.val();
    			const confirmPasswordValue = $confirmPasswordInput.val();
    			
    			let isValid = true;
    			
    			if (fullNameValue==="") {
    				$fullNameInput.addClass('is-invalid');
    				$fullNameError.text('이름을 입력해 주세요.').addClass('text-danger');
    				isValid = false;
    			}
    			if (phoneValue==="") {
    				$phoneInput.addClass('is-invalid');
    				$phoneError.text('전화번호를 입력해 주세요.').addClass('text-danger');
    				isValid = false;
    			}
    			
    			const passwordChangeAttempt = passwordValue !== "" || newPasswordValue !== "" || confirmPasswordValue !== "";
    			
	   			 if (passwordChangeAttempt) {
	   		            // 현재 비밀번호: 공백 검사
	   		            if (passwordValue === "") {
	   		                $passwordInput.addClass('is-invalid');
	   		                $passwordError.text('현재 비밀번호를 입력해주세요.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		            // 새 비밀번호: 공백 검사
	   		            if (newPasswordValue === "") {
	   		                $newPasswordInput.addClass('is-invalid');
	   		                $newPasswordError.text('새 비밀번호를 입력해주세요.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		            // 새 비밀번호 확인: 공백 검사
	   		            if (confirmPasswordValue === "") {
	   		                $confirmPasswordInput.addClass('is-invalid');
	   		                $confirmPasswordError.text('새 비밀번호 확인을 입력해주세요.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		            // 새 비밀번호와 확인 일치 여부 (공백이 아닐 때만 비교)
	   		            if (newPasswordValue !== "" && confirmPasswordValue !== "" && newPasswordValue !== confirmPasswordValue) {
	   		                $confirmPasswordInput.addClass('is-invalid');
	   		                $confirmPasswordError.text('새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.').addClass('text-danger');
	   		                clientIsValid = false;
	   		            }
	   		        }
    			
    			if (!isValid) {
    				if ($fullNameInput.hasClass('is-invalid')) $fullNameInput.focus();
    	            else if ($phoneInput.hasClass('is-invalid')) $phoneInput.focus();
    	            else if ($passwordInput.hasClass('is-invalid')) $passwordInput.focus();
    	            else if ($newPasswordInput.hasClass('is-invalid')) $newPasswordInput.focus();
    	            else if ($confirmPasswordInput.hasClass('is-invalid')) $confirmPasswordInput.focus();
    	            return; // AJAX 요청 보내지 않음
    	        }
                
    			console.log('클라이언트 유효성 검사 통과')
    			
    			const dataToSend = {
                		fullName: fullNameValue,
                		phone: phoneValue,
                		password: passwordValue,
                		newPassword: newPasswordValue,
                		confirmPassword: confirmPasswordValue
                };
                
    			$.ajax({
    	            url: 'update_profile.jsp',
    	            type: 'POST',
    	            data: dataToSend,
    	            dataType: 'json',
    	            success: function(responseFromServer) {
    	                console.log('ajax요청 성공', responseFromServer);
    	                if (responseFromServer.success) {
    	                    $updateSuccessModalLabel.text('정보 수정 완료');
    	                    $updateSuccessModalMessage.text(responseFromServer.message);
    	                    updateSuccessModal.show();
    	                    if (passwordChangeAttempt) {
    	                        $passwordInput.val('');
    	                        $newPasswordInput.val('');
    	                        $confirmPasswordInput.val('');
    	                    }
    	                    $('.profile-section h3').text(nameValue + '님');
    	                } else {
    	                    // 서버로부터 받은 에러 메시지를 해당 필드 아래에 표시 (if-else if 사용)
    	                    let $errorFieldInput = null;
    	                    let $errorFieldMessageElement = null; // 변수명 변경하여 명확화

    	                    if (responseFromServer.errorField) {
    	                        const errorField = responseFromServer.errorField;

    	                        if (errorField === "name") {
    	                            $errorFieldInput = $fullNameInput;
    	                            $errorFieldMessageElement = $fullNameError;
    	                        } else if (errorField === "phone") {
    	                            $errorFieldInput = $phoneInput;
    	                            $errorFieldMessageElement = $phoneError;
    	                        } else if (errorField === "password") { // 현재 비밀번호
    	                            $errorFieldInput = $passwordInput;
    	                            $errorFieldMessageElement = $passwordError;
    	                        } else if (errorField === "newPassword") {
    	                            $errorFieldInput = $newPasswordInput;
    	                            $errorFieldMessageElement = $newPasswordError;
    	                        } else if (errorField === "confirmPassword") {
    	                            $errorFieldInput = $confirmPasswordInput;
    	                            $errorFieldMessageElement = $confirmPasswordError;
    	                        } else if (errorField === "auth") {
    	                            alert(responseFromServer.message);
    	                            window.location.href = "signin.jsp?error=auth_required";
    	                            return; // 추가 처리 중단
    	                        }

    	                        if ($errorFieldInput && $errorFieldMessageElement) {
    	                            $errorFieldInput.addClass('is-invalid').focus();
    	                            $errorFieldMessageElement.text(responseFromServer.message).addClass('text-danger');
    	                        } else {
    	                            // errorField가 있지만 위 case에 해당하지 않는 경우 (예상치 못한 값)
    	                            $updateSuccessModalLabel.text('정보 수정 실패');
    	                            $updateSuccessModalMessage.text(responseFromServer.message || "정보 수정 중 오류가 발생했습니다.");
    	                            updateSuccessModal.show();
    	                        }
    	                    } else {
    	                        // errorField 자체가 없는 실패 응답
    	                        $updateSuccessModalLabel.text('정보 수정 실패');
    	                        $updateSuccessModalMessage.text(responseFromServer.message || "알 수 없는 오류가 발생했습니다.");
    	                        updateSuccessModal.show();
    	                    }
    	                }
    	            },
    	            error: function(jqXHR, textStatus, errorThrown) {
    	                console.log('ajax요청 실패', textStatus, '오류:', errorThrown);
    	                $updateSuccessModalLabel.text('요청 처리 오류');
    	                $updateSuccessModalMessage.text('서버와의 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    	                updateSuccessModal.show();
    	            }
    	        });
    	        console.log('ajax요청을 보냈습니다.');
    			
    		});//이벤트발생
    	});//페이지 준비완료
    </script>
</body>
</html> 