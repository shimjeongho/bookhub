<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.vo.Book"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
String searchTerm = request.getParameter("title"); 
PostMapper keywordSearch = MybatisUtils.getMapper(PostMapper.class); 

List<Book> books = keywordSearch.bookKeywordSearch(searchTerm);

Gson gson = new Gson(); 
String json = gson.toJson(books);

out.write(json);
%>