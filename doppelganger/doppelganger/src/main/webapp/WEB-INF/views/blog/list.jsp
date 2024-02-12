<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="데일리 QnA" name="title"/>
</jsp:include>

<div class="wrap wrap_8">

  <div class="text-center mb-3">
    <a href="${contextPath}/blog/write.form">
      <button type="button" class="btn btn-outline-primary">새글작성</button>
    </a>
  </div>
  
  <div class="table-responsive">
    <table class="table align-middle">
      <thead>
        <tr>
          <td>순번</td>
          <td>제목</td>
          <td>조회수</td>
          <td>작성자</td>
          <td>작성일자</td>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${blogList}" var="b" varStatus="vs">
          <tr class="align-bottom">
            <td>${beginNo - vs.index}</td>
            <td>
              <!-- 내가 작성한 블로그의 조회수는 증가하지 않는다. -->
              <c:if test="${sessionScope.user.userNo == b.userDto.userNo}">
                <a href="${contextPath}/blog/detail.do?blogNo=${b.blogNo}">${b.title}</a>
              </c:if>
              <!-- 내가 작성하지 않았다면 조회수를 증가시킨 뒤 상세보기 요청을 한다. -->
              <c:if test="${sessionScope.user.userNo != b.userDto.userNo}">
                <a href="${contextPath}/blog/increseHit.do?blogNo=${b.blogNo}">${b.title}</a>
              </c:if>
            </td>
            <td>${b.hit}</td>
            <td>${b.userDto.email}</td>
            <td>${b.createdAt}</td>
          </tr>
        </c:forEach>
      </tbody>
      <tfoot>
        <tr>
          <td colspan="5">${paging}</td>
        </tr>
      </tfoot>
    </table>
  </div>

</div>

<script>

  const fnAddResult = () => {
    let addResult = '${addResult}';  // '', '1', '0'
    if(addResult !== ''){
      if(addResult === '1'){
        alert('블로그가 작성되었습니다.');
      } else {
        alert('블로그 작성이 실패했습니다.');
      }
    }
  }
  
  const fnRemoveResult = () => {
    let removeResult = '${removeResult}';  // '', '1', '0'
    if(removeResult !== ''){
      if(removeResult === '1'){
        alert('블로그가 삭제되었습니다.');
        $('#upload_list').empty();
      } else {
        alert('블로그 삭제가 실패했습니다.');
      }
    }
  }

  fnAddResult();
  fnRemoveResult();
  
</script>

<%@ include file="../layout/footer.jsp" %>