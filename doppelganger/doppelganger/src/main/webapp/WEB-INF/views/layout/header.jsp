<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>
  <c:if test="${empty param.title}">도플갱어</c:if>
  <c:if test="${not empty param.title}">${param.title}</c:if>
</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
<link rel="stylesheet" href="${contextPath}/resources/css/init.css?dt=${dt}" />
<link rel="stylesheet" href="${contextPath}/resources/css/header.css?dt=${dt}" />
<link rel="stylesheet" href="${contextPath}/resources/css/main.css?dt=${dt}" />
<link rel="stylesheet" href="${contextPath}/resources/css/footer.css?dt=${dt}" />
<link rel="stylesheet" href="${contextPath}/resources/css/paging.css?dt=${dt}" />
<link rel="stylesheet" href="${contextPath}/resources/css/common.css?dt=${dt}" />
<link rel="stylesheet" href="${contextPath}/resources/css/ckeditor.css?dt=${dt}" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/40.0.0/decoupled-document/ckeditor.js"></script>
</head>
<body>

  <div class="header_wrap">
    <div class="logo"></div>
    <div class="login_wrap">
      <c:if test="${sessionScope.user == null}">
        <ul class="ico_user_group">
          <li><a href="${contextPath}/user/login.form"><i class="fa-solid fa-arrow-right-to-bracket"></i> 로그인</a></li>
          <li><a href="${contextPath}/user/agree.form"><i class="fa-solid fa-user-plus"></i> 회원가입</a></li>
        </ul>
      </c:if>
      <c:if test="${sessionScope.user != null}">
        <ul class="ico_user_group">
          <li>${sessionScope.user.name}님 환영합니다</li>
          <li><a href="${contextPath}/user/logout.do"><i class="fa-solid fa-arrow-left"></i> 로그아웃</a></li>
        </ul>
      </c:if>
    </div>
    <div class="gnb_wrap">
      <ul class="gnb">
        <li><a href="${contextPath}/free/list.do">마음의 소리</a></li>
        <li><a href="${contextPath}/blog/list.do">데일리 QnA</a></li>
        <li><a href="${contextPath}/upload/list.do">아이덴티티 탐구실</a></li>
        <li><a href="${contextPath}/user/mypage.form"><i class="fa-solid fa-user-pen"></i></a></li>
      </ul>
    </div>
  </div>
  
  <div class="main_wrap">
  
  <script>
    const fnMain = () => {
    	$('.logo').click(() => {
    		location.href = '${contextPath}/main.do';
    	})
    }
    fnMain();
  </script>
  