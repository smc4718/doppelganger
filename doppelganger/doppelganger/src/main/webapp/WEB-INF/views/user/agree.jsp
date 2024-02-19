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
      <textarea rows="5" class="form-control">도플갱어 서비스 및 제품(이하 ‘서비스’)을 이용해 주셔서 감사합니다. 본 약관은 다양한 도플갱어 서비스의 이용과 관련하여 도플갱어 서비스를 제공하는 도플 주식회사(이하 ‘도플갱어’)와 이를 이용하는 도플갱어 서비스 회원(이하 ‘회원’) 또는 비회원과의 관계를 설명하며, 아울러 여러분의 도플갱어 서비스 이용에 도움이 될 수 있는 유익한 정보를 포함하고 있습니다.</textarea>
    </div>
    
    <div class="form-check mt-3">
      <input type="checkbox" name="event" class="form-check-input chk_each" id="event">
      <label class="form-check-label" for="event">
        이벤트 알림 동의(선택)
      </label>
    </div>
    <div>
      <textarea rows="5" class="form-control">본인은 도플갱어 서비스 이벤트에 대한 알림을 수신하는 것에 동의하며, 이를 통해 특별한 혜택 및 프로모션에 대한 정보를 제공받고 싶습니다. 이벤트 관련 소식을 통해 서비스 이용에 도움이 되는 정보를 얻고자 합니다. 따라서 이벤트 알림을 통해 회원으로서의 경험을 더욱 향상시키고 싶습니다. 또한, 알림 수신을 통해 다양한 이벤트에 참여하여 커뮤니티에 더욱 적극적으로 참여하고 싶습니다. 이벤트 알림을 통해 새로운 기회와 즐거움을 경험하고자 합니다. 마지막으로, 언제든지 알림 설정을 변경하거나 거부할 수 있음을 알고 있습니다.</textarea>
    </div>

    <div class="mt-3 text-center">
      <button type="submit" class="btn btn-primary">다음</button>
    </div>
    
  </form>

</div>

<%@ include file="../layout/footer.jsp" %>