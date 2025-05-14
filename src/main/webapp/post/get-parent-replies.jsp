<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.Pagination"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"
    trimDirectiveWhitespaces="true"%>
<%
	int postNo = StringUtils.strToInt(request.getParameter("postNo"));
	int pageNo = StringUtils.strToInt(request.getParameter("currentPage")); 
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	
	Map<String,Object> condition = new HashMap<>();
	condition.put("postNo",postNo);
	
	int totalRows = mapper.totalRowsParentReply(condition);
	
	Pagination pnt = new Pagination(pageNo,totalRows,5);
	
	condition.put("offset",pnt.getOffset());
	condition.put("rows",pnt.getRows());
	
	List<PostReply> parentReply = mapper.getParentPostReplies(condition);
	
	Gson gson = new GsonBuilder().setDateFormat("YYYY-MM-dd").create();
	
	String json = gson.toJson(parentReply);
	out.write(json);
%>