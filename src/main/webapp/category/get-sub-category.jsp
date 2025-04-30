<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.vo.Category"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.CategoryBooksMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	int categoryNo = StringUtils.strToInt(request.getParameter("categoryNo"));

	CategoryBooksMapper categoryBooksMapper = MybatisUtils.getMapper(CategoryBooksMapper.class);
	List<Category> subCategories = categoryBooksMapper.getSubCategory(categoryNo);
	
	Gson gson = new Gson();
	String json = gson.toJson(subCategories);
	
	out.write(json);
%>