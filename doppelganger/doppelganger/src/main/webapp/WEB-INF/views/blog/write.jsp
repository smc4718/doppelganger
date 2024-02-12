<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="QnA작성" name="title"/>
</jsp:include>

<div class="wrap wrap_9">

  <h1 class="title">QnA를 작성하세요</h1>

  <form id="frm_blog_add" method="post" action="${contextPath}/blog/addBlog.do">
    
    <div>
      <label for="title">제목</label>
      <input type="text" name="title" id="title" class="form-control">
    </div>
    
    <div>
      <label for="contents">내용</label>
      <textarea name="contents" id="contents" style="display: none;"></textarea>
      <div id="toolbar-container"></div>
      <div id="ckeditor"></div>
    </div>
    
    <div class="text-center my-3">
      <a href="${contextPath}/blog/list.do">
        <button class="btn btn-secondary" type="button">작성취소</button>
      </a>
      <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
      <button class="btn btn-primary" type="submit">작성완료</button>
    </div>
    
  </form>

</div>

<script>

  const fnCkeditor = () => {
	  DecoupledEditor
      .create(document.getElementById('ckeditor'), {
    	  ckfinder: {
          // 이미지 업로드 경로
          uploadUrl: '${contextPath}/blog/imageUpload.do'    		  
    		}
  	  })
      .then(editor => {
        const toolbarContainer = document.getElementById('toolbar-container');
        toolbarContainer.appendChild(editor.ui.view.toolbar.element);
      })
      .catch(error => {
        console.error(error);
      });
  }
  
  const fnBlogAdd = () => {
	  $('#frm_blog_add').submit((ev) => {
      if($('#title').val() === ''){
        alert('제목은 반드시 입력해야 합니다.');
        ev.preventDefault();
        return;
      }
		  $('#contents').val($('#ckeditor').html());
	  })
  }
  
  fnCkeditor();
  fnBlogAdd();
  
</script>

<%@ include file="../layout/footer.jsp" %>