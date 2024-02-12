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

  <h1 class="title">탐구 게시글 수정</h1>

  <form id="frm_upload_edit" method="post" action="${contextPath}/upload/modify.do">
  
    <div class="mb-3 row">
      <label for="email" class="col-sm-2 col-form-label">작성자</label>
      <div class="col-sm-10">
        <input type="text" readonly class="form-control-plaintext" id="email" value="${upload.userDto.name}">
      </div>
    </div>
    
    <div class="mb-3 row">
      <label for="createdAt" class="col-sm-2 col-form-label">작성일</label>
      <div class="col-sm-10">
        <input type="text" readonly class="form-control-plaintext" id="createdAt" value="${upload.createdAt}">
      </div>
    </div>
    
    <div class="mb-3 row">
      <label for="modifiedAt" class="col-sm-2 col-form-label">작성일</label>
      <div class="col-sm-10">
        <input type="text" readonly class="form-control-plaintext" id="modifiedAt" value="${upload.modifiedAt}">
      </div>
    </div>
    
    <div class="mb-3">
      <label for="title" class="form-label">제목</label>
      <input type="text" name="title" value="${upload.title}" id="title" class="form-control">
    </div>
    
    <div class="mb-3">
      <label for="contents" class="form-label">내용</label>
      <textarea name="contents" id="contents" class="form-control" rows="3">${upload.contents}</textarea>
    </div>
    
    <!-- 첨부 추가 -->
    <c:if test="${sessionScope.user.userNo == upload.userDto.userNo}">
      <h5>신규 첨부</h5>
      <div class="input-group">
        <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
        <input type="file" name="files" id="files"  class="form-control" multiple>
        <button class="btn btn-outline-secondary" type="button" id="btn_add_attach">첨부추가하기</button>
      </div>
      <div class="attached_list mt-3" id="attached_list"></div>
    </c:if>
    
    <hr class="my-3">

    <!-- 첨부 목록에서 삭제 -->
    <h5>기존 첨부 목록</h5>
    <div id="attach_list"></div>

    <c:if test="${sessionScope.user.userNo == upload.userDto.userNo}">
      <div class="text-center my-3">
        <a href="${contextPath}/upload/detail.do?uploadNo=${upload.uploadNo}">
          <button class="btn btn-secondary" type="button">돌아가기</button>
        </a>
        <input type="hidden" name="uploadNo" value="${upload.uploadNo}">
        <button type="submit" id="btn_modify" class="btn btn-success">수정하기</button>
      </div>
    </c:if>

  </form>
  
</div>
  
<script>

  const fnFileCheck = () => {
    $('#files').change((ev) => {
      $('#attached_list').empty();
      let maxSize = 1024 * 1024 * 100;
      let maxSizePerFile = 1024 * 1024 * 10;
      let totalSize = 0;
      let files = ev.target.files;
      for(let i = 0; i < files.length; i++){
        totalSize += files[i].size;
        if(files[i].size > maxSizePerFile){
          alert('각 첨부파일의 최대 크기는 10MB입니다.');
          $(ev.target).val('');
          $('#attached_list').empty();
          return;
        }
        $('#attached_list').append('<div>' + files[i].name + '</div>');
      }
      if(totalSize > maxSize){
        alert('전체 첨부파일의 최대 크기는 100MB입니다.');
        $(ev.target).val('');
        $('#attached_list').empty();
        return;
      }
    })
  }
  
  const fnAddAttach = () => {
    $('#btn_add_attach').click(() => {
      // 폼을 FormData 객체로 생성한다.
      let formData = new FormData();
      // 첨부된 파일들을 FormData에 추가한다.
      let files = $('#files').prop('files');
      $.each(files, (i, file) => {
        formData.append('files', file);  // 폼에 포함된 파라미터명은 files이다. files는 여러 개의 파일을 가지고 있다.
      })
      // 현재 게시글 번호(uploadNo)를 FormData에 추가한다.
      formData.append('uploadNo', '${upload.uploadNo}');
      // FormData 객체를 보내서 저장한다.
      $.ajax({
        // 요청
        type: 'post',
        url: '${contextPath}/upload/addAttach.do',
        data: formData,
        contentType: false,
        processData: false,
        // 응답
        dataType: 'json',
        success: (resData) => {  // resData = {"attachResult": true}
          if(resData.attachResult){
            alert('첨부 파일이 추가되었습니다.');
            fnAttachList();
          } else {
            alert('첨부 파일이 추가되지 않았습니다.');
          }
          $('#files').val('');
        }
      })
    })
  }

  const fnAttachList = () => {
    $.ajax({
      // 요청
      type: 'get',
      url: '${contextPath}/upload/getAttachList.do',
      data: 'uploadNo=${upload.uploadNo}',
      // 응답
      dataType: 'json',
      success: (resData) => {  // resData = {"attachList": []}
        $('#attach_list').empty();
        $.each(resData.attachList, (i, attach) => {
          let str = '<div class="attach">';
          if(attach.hasThumbnail === 0){
        	  str += '<img src="${contextPath}/resources/image/attach1.png">';
          } else {        	  
            str += '<img src="${contextPath}' + attach.path + '/s_' + attach.filesystemName + '">';
          }
          str += '<span style="margin: 0 10px;">' + attach.originalFilename + '</span>';
          if('${sessionScope.user.userNo}' === '${upload.userDto.userNo}'){            
            str += '<a data-attach_no="' + attach.attachNo + '"><i class="fa-regular fa-circle-xmark ico_remove_attach"></i></a>';
          }
          str += '</div>';
          $('#attach_list').append(str);
        })
      }
    })
  }
  
  const fnRemoveAttach = () => {
    $(document).on('click', '.ico_remove_attach', (ev) => {
      if(!confirm('해당 첨부 파일을 삭제할까요?')){
        return;
      }
      $.ajax({
        // 요청
        type: 'post',
        url: '${contextPath}/upload/removeAttach.do',
        data: 'attachNo=' + $(ev.target).parent().data('attach_no'),
        // 응답
        dataType: 'json',
        success: (resData) => {  // resData = {"removeResult": 1}
          if(resData.removeResult === 1){
            alert('해당 첨부 파일이 삭제되었습니다.');
            fnAttachList();
          } else {
            alert('해당 첨부 파일이 삭제되지 않았습니다.');
          }
        }
      })
    })
  }
  
  const fnModifyAttach = () => {
	  $('#frm_upload_edit').submit((ev) => {
      if($('#title').val() === ''){
        alert('제목은 반드시 입력해야 합니다.');
        $('#title').focus();
        ev.preventDefault();
        return;
      } else if($('#files').val() !== ''){
    	  alert('새로운 첨부가 있는 경우 첨부추가하기 버튼을 먼저 클릭해 주세요.');
    	  $('#btn_add_attach').focus();
    	  ev.preventDefault();
        return;
      }
	  })
  }

  fnFileCheck();
  fnAddAttach();
  fnAttachList();
  fnRemoveAttach();
  fnModifyAttach();
  
</script>
  
<%@ include file="../layout/footer.jsp" %>