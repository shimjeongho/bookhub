<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
/* ajax를 처리하는 jsp 파일 
   - 도서 문의 게시판에서 도서검색 선택 -> 모달창 내 키워드 입력하고 -> 검색 버튼을 누름 
   - 그 키워드에 포함된 도서 정보를 동적으로 처리하기 위해, 가져오는 파일 
   
   1. 서버로 보내진 searchTerm 값을 가져온다.
   2. PostMapper을 사용할 수 있도록 설정한다. 
   3. searchTerm과 PostMapper의 쿼리문을 조합하여 실행하고 
   4. 실행된 값을 list 객체에 담는다.
   5. list에 담긴 값들을 json 형태로 변환한다. 
   6. 그 값들을 서버에 응답한다. 
*/
String searchTerm = request.getParameter("title"); 
PostMapper keywordSearch = MybatisUtils.getMapper(PostMapper.class); 

List<Book> books = keywordSearch.bookKeywordSearch(searchTerm);

Gson gson = new Gson(); 
String json = gson.toJson(books);

out.write(json);
%>