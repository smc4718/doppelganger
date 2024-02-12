<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="게시글 작성" name="title"/>
</jsp:include>

<div class="wrap wrap_6">

  <h1 class="title">마음의소리 작성</h1>

  <form id="frm_free_add" method="post" action="${contextPath}/free/add.do">
    
    <div class="mb-3 row">
      <label for="email" class="col-sm-2 col-form-label">작성자</label>
      <div class="col-sm-10"><input type="text" readonly class="form-control-plaintext" id="email" name="email" value="${sessionScope.user.email}"></div>
    </div>
    <div class="input-group">
      <span class="input-group-text">내용</span>
      <textarea rows="5" name="contents" id="contents" class="form-control"></textarea>
    </div>
    <div class="text-center mt-3">
      <a href="${contextPath}/free/list.do">
        <button class="btn btn-secondary" type="button">작성취소</button>
      </a>
      <button type="submit" class="btn btn-primary">작성완료</button>
    </div>
    
  </form>

</div>

<script>

  const fnSubmit = () => {
    $('#frm_free_add').submit((ev) => {
      if($('#contents').val() === ''){
        alert('내용은 반드시 입력해야 합니다.');
        $('#contents').focus();
        ev.preventDefault();
        return;
      }
    })
  }
  
  fnSubmit();

</script>

<%@ include file="../layout/footer.jsp" %>