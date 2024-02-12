<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="약관동의" name="title"/>
</jsp:include>

<script src="${contextPath}/resources/js/user_agree.js"></script>

<div class="wrap wrap_5">

  <h1 class="title">약관 동의하기</h1>

  <form id="frm_agree" action="${contextPath}/user/join.form">
  
    <div class="form-check mt-3">
      <input type="checkbox" class="form-check-input" id="chk_all">
      <label class="form-check-label" for="chk_all">
        모두 동의합니다
      </label>
    </div>

    <hr class="my-2">
    
    <div class="form-check mt-3">
      <input type="checkbox" name="service" class="form-check-input chk_each" id="service">
      <label class="form-check-label" for="service">
        서비스 이용약관 동의(필수)
      </label>
    </div>
    <div>
      <textarea rows="5" class="form-control">본 약관은 ...</textarea>
    </div>
    
    <div class="form-check mt-3">
      <input type="checkbox" name="event" class="form-check-input chk_each" id="event">
      <label class="form-check-label" for="event">
        이벤트 알림 동의(선택)
      </label>
    </div>
    <div>
      <textarea rows="5" class="form-control">본 약관은 ...</textarea>
    </div>

    <div class="mt-3 text-center">
      <button type="submit" class="btn btn-primary">다음</button>
    </div>
    
  </form>

</div>

<%@ include file="../layout/footer.jsp" %>