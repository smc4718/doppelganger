<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="비밀번호변경" name="title"/>
</jsp:include>

<script src="${contextPath}/resources/js/user_modify_pw.js?dt=${dt}"></script>

<div class="wrap wrap_7">

  <h1 class="title">비밀번호 변경하기</h1>

  <form id="frm_modify_pw" class="mt-5" method="post" action="${contextPath}/user/modifyPw.do">
      
    <div class="row mb-2">
      <label for="pw" class="col-sm-3 col-form-label">비밀번호</label>
      <div class="col-sm-9"><input type="password" name="pw" id="pw" class="form-control"></div>
      <div class="col-sm-3"></div>
      <div class="col-sm-9 mb-3" id="msg_pw"></div>
    </div>
    
    <div class="row mb-2">
      <label for="pw2" class="col-sm-3 col-form-label">비밀번호 확인</label>
      <div class="col-sm-9"><input type="password" id="pw2" class="form-control"></div>
      <div class="col-sm-3"></div>
      <div class="col-sm-9 mb-3" id="msg_pw2"></div>
    </div>
    
    <div class="text-center mt-3">
      <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
      <button type="submit" class="btn btn-primary">비밀번호변경하기</button>
    </div>
    
  </form>

</div>

<%@ include file="../layout/footer.jsp" %>