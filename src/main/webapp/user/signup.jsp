<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 북허브</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Daum Postcode 
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>-->
    <!-- Custom CSS -->
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <%@ include file="../common/nav.jsp" %>

    <!-- Signup Form -->
    <div class="signup-container">
        <h2 class="text-center mb-4">회원가입</h2>
        <form action="register.jsp" method="post" id="register">
            <div class="mb-3">
                <label for="id" class="form-label required">아이디</label>
                <div style="display: flex; gap: 1em;">
                	<input type="text" class="form-control" id="id" name="id" placeholder="example@example.com" >
                	<button class="btn btn-outline-primary" type="button" id="checkIdBtn"
                		style="white-space: nowrap;">중복확인</button>
                </div>
                <div id="idCheckResult" class="form-text mt-1"></div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label required">비밀번호</label>
                <input type="password" class="form-control" id="password" name="password" >
                <div class="password-requirements">
                    비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.
                </div>
                <div id="password-feedback" class="form-text mt-1"></div>
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label required">비밀번호 확인</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                <div id="confirmPassword-feedback" class="form-text mt-1"></div>
            </div>

            <div class="mb-3">
                <label for="fullName" class="form-label required">이름</label>
                <input type="text" class="form-control" id="fullName" placeholder="이름을 입력해 주세요" name="name" >
                <div id="fullName-feedback" class="form-text mt-1"></div>
            </div>
            
            <div class="mb-3">
                <label for="birth" class="form-label required">생년월일</label>
                <input type="date" class="form-control" id="birth" name="birth">
                <div id="birth-feedback" class="form-text mt-1"></div>
            </div>
            
			<div class="mb-3">
                <label for="phone" class="form-label required">핸드폰 번호</label>
                <input type="tel" class="form-control" id="phone" name="phone" placeholder="예: 010-1234-5678">
                 <div class="form-text">하이픈(-)을 포함하여 입력해주세요.</div> 
                 <div id="phone-feedback" class="form-text mt-1"></div>
            </div>

            <div class="mb-3">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="agreeTerms">
                    <label class="form-check-label required" for="agreeTerms">
                        이용약관 및 개인정보 처리방침에 동의합니다
                    </label>
                </div>
                <div id="agreeTerms-feedback" class="form-text mt-1"></div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">가입하기</button>
                <a href="home.html" class="btn btn-outline-secondary">취소</a>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer class="footer mt-5">
        <div class="container">
            <div class="text-center">
                <small class="text-muted">&copy; 2025 북허브. All rights reserved.</small>
            </div>
        </div>
    </footer>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Daum Postcode Script -->
    <script>
    	$(document).ready(function() {
    		
    		// 18. 아이디 중복 확인 통과 여부를 저장할 변수 (깃발)
    	    //     처음에는 false (아직 확인 안 함 또는 실패)로 시작합니다.
    		let emailCheckPassed = false;
    		
    		$("#checkIdBtn").click(function() {
    			
    			let $idInput = $("#id"); 
    			let trimmedEmailValue = $idInput.val().trim();
				console.log(trimmedEmailValue);
				
				let $resultDiv = $("#idCheckResult");
				
				// 모든 경우에 대해 메시지 영역을 먼저 초기화
			    $resultDiv.text("").removeClass("text-danger text-success text-warning");
				
				if (trimmedEmailValue==="") {
					console.log("아무값도 입력이 되지 않았습니다.");
					$resultDiv.text("이메일을 입력해주세요").addClass("text-danger");
					$idInput.focus();
					
					return;
				}
				//이메일 정규 표현식
				const emailRegExp = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			    if (!emailRegExp.test(trimmedEmailValue)) {
			        console.log("이메일 형식이 올바르지 않습니다.");
			        $resultDiv.text("올바른 이메일 형식을 입력해주세요. (예: example@example.com)").addClass("text-danger");
			        $idInput.focus();
			        return; // AJAX 요청 보내지 않고 여기서 중단
			    }
				
				$resultDiv.text("확인중...");
				console.log("이메일이 입력되었습니다. ajax요청을 준비합니다.");
				
				$.ajax({
					url:'check-id.jsp',
					type:'GET',
					data:{
						id:trimmedEmailValue
					},
					dataType:'text',
					success: function(response) {
						console.log(response);
						
						let serverResponse = response.trim();
						if (serverResponse ==="none") {
							console.log("사용가능한 아이디입니다");
							$resultDiv.text("사용가능한 아이디입니다").addClass("text-success");
							//깃발꼽기
							emailCheckPassed = true;
							console.log("emailCheckPassed 깃발:", emailCheckPassed);
							
							
						} else if(serverResponse==="exists") {
							console.log("사용중인 아이디입니다.");
							$resultDiv.text("사용중인 아이디입니다").addClass("text-danger");
							//기본값이 false라서 굳이 꽃을 필요 없다.
							console.log("emailCheckPassed 깃발:", emailCheckPassed);

						} else {
							console.log("서버로부터 예상치 못한 응답발생");
							$resultDiv.text("서버로부터 오류가 발생했습니다.")
							//기본값이 false라서 굳이 꽃을 필요 없다.
							console.log("emailCheckPassed 깃발:", emailCheckPassed);

						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.error("AJAX 요청 실패:", textStatus, errorThrown);
						console.error("서버 응답 내용:", jqXHR.responseText); // 서버가 보낸 에러 메시지 확인
		                $resultDiv.text("아이디 확인 중 오류가 발생했습니다. 네트워크 상태를 확인해주세요.").addClass("text-danger");
		             	//기본값이 false라서 굳이 꽃을 필요 없다.
						console.log("emailCheckPassed 깃발:", emailCheckPassed);

					}
					
				}); //ajax호출 끝
    			
    		}); // $("#checkIdBtn").click 끝
    		
    		
    		//아이디의 입력칸의 내용이 변경될 때마다 감지하는 이벤트 핸들러
    		$("#id").on("input", function() {
    			
    			if (emailCheckPassed === true) {
    				console.log("중복확인 통과후 아이디가 수정됨.")
    				emailCheckPassed = false;
    				
    				let $resultDiv = $("#idCheckResult");
    	            $resultDiv.text("이메일이 변경되었습니다. 중복 확인을 다시 해주세요.").removeClass("text-success text-danger").addClass("text-warning");
    			}
    			console.log("현재 emailCheckPassed 깃발:", emailCheckPassed);
    		});
    		
    		$("#register").submit(function(event){
    			console.log("폼제출 시도됨");
    			//유효성 검사통과여부를 나타내는 깃발.
    			let isValid = true;
    			//이전 오류메세지 삭제
    			$("#idCheckResult").text("").removeClass("text-danger text-success text-warning");
    			$("#id").text("").removeClass("is-invalid");
    	        $("#password-feedback").text("").removeClass("text-danger");
    	        $("#password").text("").removeClass("is-invalid");
    	        $("#confirmPassword-feedback").text("").removeClass("text-danger");
    	        $("#confirmPassword").text("").removeClass("is-invalid");
    	        $("#fullName-feedback").text("").removeClass("text-danger"); 
    	        $("#fullName").text("").removeClass("is-invalid"); 
    	        $("#birth-feedback").text("").removeClass("text-danger");    
    	        $("#birth").text("").removeClass("is-invalid");    
    	        $("#phone-feedback").text("").removeClass("text-danger");
    	        $("#phone").text("").removeClass("is-invalid");
    	        $("#agreeTerms-feedback").text("").removeClass("text-danger"); 

				//아이디 유효성 검사    			
    			let $idInput = $("#id");
    	        let trimmedEmailValue = $idInput.val().trim();
    			let $idResultDiv = $("#idCheckResult"); 
    			
    			if (trimmedEmailValue === "") {
    				$idResultDiv.text("이메일을 입력해 주세요").addClass("text-danger");
    				if (isValid) {
    					$idInput.focus();
    					$idInput.addClass('is-invalid');
    					isValid = false;
    				}
    			} else if (emailCheckPassed ===false) {
    				$idResultDiv.text("이메일 중복체크를 해주세요").addClass("text-danger");
    				if (isValid) {
    					$("#checkIdBtn").focus();
    					isValid = false;
    				}
    			}
    			
    			//비밀번호 유효성 검사
    			let $passwordInput = $("#password");
    	        let passwordValue = $passwordInput.val();
    	        let $passwordFeedback = $("#password-feedback");
    	        let passwordRegExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
    	        
    	        if (passwordValue === "") {
    	            console.log("가입 시도: 비밀번호가 비어있음");
    	            $passwordFeedback.text("비밀번호를 입력해주세요.").addClass("text-danger");
    	            if (isValid) {
    					$passwordInput.focus();
    				    $passwordInput.addClass('is-invalid');
    					isValid = false;
    	            }
    	        } else if (!passwordRegExp.test(passwordValue)) {
    	            console.log("가입 시도: 비밀번호 복잡성 부족");
    	            $passwordFeedback.text("비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.").addClass("text-danger");
    	            if (isValid) {
    					$passwordInput.focus();
    					$passwordInput.addClass('is-invalid');
    					isValid = false;
    	            }
    	        }
    	            
    	        let $confirmPasswordInput = $("#confirmPassword");
    	        let confirmPasswordValue = $confirmPasswordInput.val();
    	        let $confirmPasswordFeedback = $("#confirmPassword-feedback");
    	        
    	        if (confirmPasswordValue === "") {
    	            console.log("가입 시도: 비밀번호 확인이 비어있음");
    	            $confirmPasswordFeedback.text("비밀번호 확인을 입력해주세요.").addClass("text-danger");
    	            if (isValid) {
    	            	$confirmPasswordInput.focus();
    	            	$confirmPasswordInput.addClass('is-invalid');
    					isValid = false;
    	            }
    	        } else if (passwordValue !== confirmPasswordValue) {
    	            // 이 검사는 passwordValue가 비어있지 않을 때 의미가 있습니다.
    	            // (위에서 passwordValue가 비어있으면 이미 isValid=false가 되었을 것이므로 괜찮습니다)
    	            console.log("가입 시도: 비밀번호 불일치");
    	            $confirmPasswordFeedback.text("비밀번호가 일치하지 않습니다.").addClass("text-danger");
    	            if (isValid) {
    	            	$confirmPasswordInput.focus();
    	            	$confirmPasswordInput.addClass('is-invalid');
    					isValid = false;
    	            }
    	        }
    	        
    	        let $fullNameInput = $("#fullName");
    	        let fullNameValue = $fullNameInput.val().trim();
    	        let $fullNameFeedback = $("#fullName-feedback");

    	        if (fullNameValue === "") {
    	            console.log("가입 시도: 이름이 비어있음");
    	            $fullNameFeedback.text("이름을 입력해주세요.").addClass("text-danger");
    	            if (isValid) $fullNameInput.focus();
    	            if (isValid) $fullNameInput.addClass('is-invalid');
    	            isValid = false;
    	        }
    	        
    	        let $birthInput = $("#birth");
    	        let birthValue = $birthInput.val(); // date 타입은 .trim() 불필요
    	        let $birthFeedback = $("#birth-feedback");

    	        if (birthValue === "") {
    	            console.log("가입 시도: 생년월일이 비어있음");
    	            $birthFeedback.text("생년월일을 입력해주세요.").addClass("text-danger");
    	            if (isValid) $birthInput.focus();
    	            if (isValid) $birthInput.addClass('is-invalid');
    	            isValid = false;
    	        }
    	        
    	        let $phoneInput = $("#phone");
    	        let phoneValue = $phoneInput.val().trim();
    	        let $phoneFeedback = $("#phone-feedback");
    	        let phoneRegExp = /^[0-9]{3}-[0-9]{3,4}-[0-9]{4}$/;

    	        if (phoneValue === "") {
    	            console.log("가입 시도: 핸드폰 번호가 비어있음");
    	            $phoneFeedback.text("핸드폰 번호를 입력해주세요.").addClass("text-danger");
    	            if (isValid) $phoneInput.focus();
    	            if (isValid) $phoneInput.addClass('is-invalid');
    	            isValid = false;
    	        } else if (!phoneRegExp.test(phoneValue)) {
    	            console.log("가입 시도: 핸드폰 번호 형식 오류");
    	            $phoneFeedback.text("핸드폰 번호 형식이 올바르지 않습니다. (예: 010-1234-5678)").addClass("text-danger");
    	            if (isValid) $phoneInput.focus();
    	            if (isValid) $phoneInput.addClass('is-invalid');
    	            isValid = false;
    	        }
    	        
    	        let $agreeTermsCheckbox = $("#agreeTerms");
    	        let $agreeTermsFeedback = $("#agreeTerms-feedback");

    	        // 체크박스는 .val()이 아니라 .is(":checked")로 확인합니다.
    	        if (!$agreeTermsCheckbox.is(":checked")) {
    	            console.log("가입 시도: 이용약관 미동의");
    	            $agreeTermsFeedback.text("이용약관 및 개인정보 처리방침에 동의해주세요.").addClass("text-danger");
    	            isValid = false;
    	        }
    	        
    	        
    			//최종확인
    			if (isValid === false) {
    		            console.log("유효성 검사 실패. 폼 제출을 막습니다.");
    		            event.preventDefault();
    			} else {
    				console.log("유효성 검사 통과. 폼제출을 진행합니다");
    			}
    		});// $("#register-form").submit 끝
    	});// $(document).ready 끝
    </script>
</body>
</html> 