<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="${upload.uploadNo}번 게시글" name="title"/>
</jsp:include>

<div class="wrap wrap_6">

  <h1 class="title">탐구 게시글</h1>
  
  <div class="text-center mb-5">
    <c:if test="${sessionScope.user.userNo == upload.userDto.userNo}">
      <form id="frm_btn">
        <input type="hidden" name="uploadNo" value="${upload.uploadNo}">
        <button type="button" id="btn_edit" class="btn btn-warning btn-sm">편집</button>
        <button type="button" id="btn_remove" class="btn btn-danger btn-sm">삭제</button>
      </form>
    </c:if>
  </div>
  <div>작성자 : ${upload.userDto.name}</div>
  <div>작성일 : ${upload.createdAt}</div>
  <div>수정일 : ${upload.modifiedAt}</div>
  <div>제목 : ${upload.title}</div>
  <div>내용</div>
  <div>
    <c:if test="${empty upload.contents}">
      내용없음
    </c:if>
    <c:if test="${not empty upload.contents}">
      ${upload.contents}
    </c:if>
  </div>
  
  <hr class="my-3">
  
  <h5>첨부 다운로드</h5>
  <div>
    <c:if test="${empty attachList}">
      <div>첨부 없음</div>
    </c:if>
    <c:if test="${not empty attachList}">
      <c:forEach items="${attachList}" var="atc">
        <div class="attach" data-attach_no="${atc.attachNo}">
          <c:if test="${atc.hasThumbnail == 1}">
            <img src="${contextPath}${atc.path}/s_${atc.filesystemName}" alt="썸네일">
          </c:if>
          <c:if test="${atc.hasThumbnail == 0}">
            <img src="${contextPath}/resources/image/attach1.png" alt="썸네일">
          </c:if>
          <a>${atc.originalFilename}</a>
        </div>
      </c:forEach>
      <div><a href="${contextPath}/upload/downloadAll.do?uploadNo=${upload.uploadNo}">모두 다운로드</a></div>
    </c:if>
  </div>
  
</div>
  
<script>

  var frmBtn = $('#frm_btn');

  const fnEdit = () => {
    $('#btn_edit').click(() => {
      frmBtn.attr('action', '${contextPath}/upload/edit.form');
      frmBtn.attr('method', 'get');
      frmBtn.submit();
    })
  }
  
  const fnRemove = () => {
    $('#btn_remove').click(() => {
      if(confirm('해당 게시글을 삭제할까요?')){
        frmBtn.attr('action', '${contextPath}/upload/removeUpload.do');
        frmBtn.attr('method', 'post');
        frmBtn.submit();
      }
    })
  }

  const fnDownload = () => {
    $('.attach').click(function(){
      if(confirm('다운로드 할까요?')){
        location.href = '${contextPath}/upload/download.do?attachNo=' + $(this).data('attach_no');
      }
    })
  }
  
  const fnModifyResult = () => {
    let modifyResult = '${modifyResult}';
    if(modifyResult !== ''){
      if(modifyResult === '1'){
        alert('게시글이 수정되었습니다.');
      } else {
        alert('게시글이 수정되지 않았습니다.');
      }
    }
  }
  
  fnEdit();
  fnRemove();
  fnDownload();
  fnModifyResult();
  
</script>
  
<%@ include file="../layout/footer.jsp" %>