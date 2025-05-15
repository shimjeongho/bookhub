<%@page import="kr.co.bookhub.vo.Library"%>
<%@page import="kr.co.bookhub.vo.Stock"%>
<%@page import="kr.co.bookhub.mapper.LibraryMapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	LibraryMapper libraryMapper = MybatisUtils.getMapper(LibraryMapper.class);
	List<Library> libraries = libraryMapper.getLibrary();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <title>도서관 상세 정보</title>
    <link href="../resources/css/styles.css" rel="stylesheet">
</head>
<body>
    <%@ include file="../common/nav.jsp" %>

    <div class="container py-5">
       <h2 class="text-center mb-4">도서관 상세 정보</h2>
        <div class="row library-grid">
         <%
             for (Library library : libraries) {
         %> 
                     <!-- 도서관 정보 카드 -->
                     <div class="col-lg-6 mb-4">
                         <div class="card library-card">
                             <!-- 도서관 이미지 -->
                             <img src="<%=library.getImgPath()%>" class="card-img-top" alt="도서관 전경">
                             
                             <div class="card-body d-flex">
                             	<div class="col-7">
                             		<h3 class="card-title mb-4"><%=library.getName()%></h3>
                                 
	                                 <div class="info-item">
	                                     <i class="fas fa-map-marker-alt info-icon"></i>
	                                     <div>
	                                         <strong>주소</strong><br>
	                                         <%=library.getLocation()%>
	                                     </div>
	                                 </div>
	                                 
	                                 <div class="info-item">
	                                     <i class="fas fa-clock info-icon"></i>
	                                     <div>
	                                         <strong>운영시간</strong><br>
	                                         <%=library.getBusinessHours()%>
	                                     </div>
	                                 </div>
	                                 
	                                 <div class="info-item">
	                                     <i class="fas fa-phone info-icon"></i>
	                                     <div>
	                                         <strong>전화번호</strong><br>
	                                         <%=library.getTel()%>
	                                     </div>
	                                 </div>
                             	</div>
                                 
                                 
								<div class="col-5">
									<div class="d-flex flex-column gap-3">
										<div id="libraryMap-<%=library.getNo() %>" data-lat="<%=library.getLatitude() %>" data-lng="<%=library.getLongitude() %>"></div>
		                            </div>
		                        </div>
							</div>
						</div>
                     </div>	
                     
                     <!-- 지도 영역 -->
         <%
             }
         %>      
       </div>
            
    </div>

    <%@ include file="../common/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=96c737daba3c54accdf57990fa67fca4"></script>
    
    <script>
        // 카카오맵 초기화
        window.onload = function() {
        	$("[id^=libraryMap]").each(function() {
	            var container = this;
	            
	            let lat = $(this).attr("data-lat");
	            let lng = $(this).attr("data-lng");
	            
	            var options = {
	                center: new kakao.maps.LatLng(lat, lng),
	                level: 3
	            };
	            var map = new kakao.maps.Map(container, options);
	            
	            // 마커 추가
	            var markerPosition = new kakao.maps.LatLng(lat, lng);
	            var marker = new kakao.maps.Marker({
	                position: markerPosition
	            });
	            marker.setMap(map);
        		
        	})
        }
    </script>
</body>
</html>
