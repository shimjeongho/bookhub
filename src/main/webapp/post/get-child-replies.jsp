<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="kr.co.bookhub.vo.PostReply"%>
<%@page import="java.util.List"%>
<%@page import="kr.co.bookhub.util.MybatisUtils"%>
<%@page import="kr.co.bookhub.mapper.PostMapper"%>
<%@page import="kr.co.bookhub.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int postReplyNo = StringUtils.strToInt(request.getParameter("postReplyNo"));
	
	PostMapper mapper = MybatisUtils.getMapper(PostMapper.class);
	Map<String,Object> condition = new HashMap<>();
	condition.put("postReplyNo",postReplyNo);
	
	List<PostReply> childReplies = mapper.getChildPostReplies(condition);
	Gson gson = new GsonBuilder().setDateFormat("YYYY-MM-dd").create();
	String json = gson.toJson(childReplies);
	out.write(json);
%>     