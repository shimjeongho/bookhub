<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 북허브</title>
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

    <!-- Login Form -->
    <div class="login-container">
        <h2 class="text-center mb-4">로그인</h2>
        <form id="loginForm" action="login_process.jsp" method="post">
            <div class="mb-3">
                <label for="email" class="form-label required">아이디(이메일)</label>
                <input type="text" class="form-control" id="email" name="id" placeholder="example@example.com">
                <div id="emailError" class="form-text mt-1"></div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label required">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password">
                <div id="passwordError" class="form-text mt-1"></div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">로그인</button>
                <a href="signup.jsp" class="btn btn-outline-secondary">회원가입</a>
            </div>
        </form>
    </div>
    
    <!-- Bootstrap Modal (로그인 실패 시 사용) -->
	<div class="modal fade" id="loginErrorModal" tabindex="-1" aria-labelledby="loginErrorModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="loginErrorModalLabel">로그인 오류</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body" id="loginModalErrorMessage">
	                <!-- 에러 메시지가 여기에 표시됩니다. -->
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	            </div>
	        </div>
	    </div>
	</div>

    <!-- Footer -->
    <footer class="footer mt-5">
        <div class="container">
            <div class="text-center">
                <small class="text-muted">&copy; 2025 북허브. All rights reserved.</small>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS and jquery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
     
    <!-- Login Validation Script -->
    <script>
    	$(document).ready(function() {
    		const $emailInput = $('#email');
    		const $emailError = $('#emailError');
    		const $passwordInput = $('#password');
    		const $passwordError = $('#passwordError')
    		
    		//bootstrap 모달객체 미리 생성
    		const loginErrorModal = new bootstrap.Modal(document.getElementById('loginErrorModal'));
    		const $loginModalMessage = $('#loginModalErrorMessage');        
            const $loginModalLabel = $('#loginErrorModalLabel');
    		
    		$('#loginForm').on('submit',function(event) {
    			event.preventDefault();
    			console.log('폼제출 시도됨');
    			
				$emailError.text('').removeClass('text-danger');   			
				$emailInput.removeClass('is-invalid');
				$passwordError.text('').removeClass('text-danger');  
				$passwordInput.removeClass('is-invalid');
				
    			const idValue = $emailInput.val().trim();
    			const passwordValue = $passwordInput.val();
    			
    			//클라이언트측 유효성 검사
    			let isValid = true;
    			
    			if (idValue === "") {
    				$emailError.text('아이디(이메일)를 입력해주세요.').addClass('text-danger');
    				$emailInput.addClass('is-invalid');
                    isValid = false;
    			}
    			
    			if (passwordValue ==="") {
    				$passwordError.text('비밀번호를 입력해 주세요').addClass('text-danger');
    				$passwordInput.addClass('is-invalid');
    				isValid = false;
    			}
    			
    			if (!isValid) {
    				console.log('클라이언트 유효성 검사 실패');
    				if ($emailInput.hasClass('is-invalid')) {
    					$emailInput.focus();
    				} else if ($passwordInput.hasClass('is-invalid')) {
                        $passwordInput.focus();
                    }
                    return;
                }
    			
                console.log('클라이언트 유효성 검사 통과!');
    			
                //ajax보내기
                const dataToSend = {
                		id: idValue,
                		password: passwordValue
                };
                
                $.ajax({
                	url:'login_process.jsp',
                	type:'POST',
                	data:dataToSend,
                	dataType:'json',
                	success: function(responseFromServer) {
                		console.log('ajax요청 성공', responseFromServer);
                		if (responseFromServer.success)  {
                			console.log(responseFromServer.message);
                			window.location.href = responseFromServer.redirectUrl;
                			
                		} else {
                			 $loginModalLabel.text('로그인 실패'); // 타이틀 변경
                             $loginModalMessage.text(responseFromServer.message);
                             loginErrorModal.show(); // loginErrorModal 사용
                             $passwordInput.val('');
                             $passwordInput.focus();
                			 console.log(responseFromServer.message);
                		}
                	},
                	error: function(jqXHR, textStatus, errorThrown) {
                		console.log('ajax요청 실패',textStatus, '오류:', errorThrown)
                		if (jqXHR.status===404) {
                			console.error('요청한 URL을 찾을 수 없습니다 (404). login_ajax_process.jsp 파일이 정확한 위치에 있는지 확인하세요.');
                		}
                	}
                });
                console.log('ajax요청을 보냈습니다.')
    		});
    	});
    </script>
</body>
</html> 