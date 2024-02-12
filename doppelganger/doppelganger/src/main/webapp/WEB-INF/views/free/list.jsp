<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="마음의 소리" name="title"/>
</jsp:include>

<style>
  .blind {
    display: none;
  }
</style>

<div class="wrap wrap_9">

  <div class="text-center mb-3">
    <a href="${contextPath}/free/write.form">
      <button type="button" class="btn btn-outline-primary">새글작성</button>
    </a>
    <a href="${contextPath}/free/list.do">
      <button type="button" class="btn btn-outline-success">전체보기</button>
    </a>
  </div>
  
  <div class="text-center my-3">
    <form method="get" action="${contextPath}/free/search.do">
      <div class="input-group mb-3">
        <select class="form-select" name="column">
          <option value="EMAIL">작성자</option>
          <option value="CONTENTS">내용</option>
        </select>
        <input type="text" name="query" class="form-control" placeholder="검색어 입력">
        <button type="submit" class="btn btn-outline-primary btn-sm">검색</button>
      </div>
    </form>
  </div>
  
  <div>
    <table class="table">
      <thead class="table-light">
        <tr>
          <td>순번</td>
          <td>작성자</td>
          <td>내용</td>
          <td>작성일자</td>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${freeList}" var="free" varStatus="vs">
          <tr class="list">
            <td>${beginNo - vs.index}</td>
            <!-- 정상 게시글 -->            
            <c:if test="${free.status == 1}">
              <td>
                <c:if test="${free.email == null}">
                  정보없음
                </c:if>
                <c:if test="${free.email != null}">
                  ${free.email}
                </c:if>
              </td>
              <td>
                <!-- depth에 따른 들여쓰기 -->              
                <c:forEach begin="1" end="${free.depth}" step="1">&nbsp;&nbsp;</c:forEach>
                <!-- 댓글은 댓글 아이콘 부착하기 -->
                <c:if test="${free.depth != 0}">
                  <i class="fa-solid fa-share"></i>
                </c:if>
                <!-- 게시글내용 -->
                ${free.contents}
                <!-- 댓글작성버튼 -->
                <button type="button" class="btn btn-outline-dark btn-sm btn_reply">댓글</button>
                <!-- 게시글삭제버튼 -->
                <form class="frm_remove" method="post" action="${contextPath}/free/remove.do" style="display: inline;">
                  <c:if test="${free.email == sessionScope.user.email}">                  
                    <input type="hidden" name="freeNo" value="${free.freeNo}">
                    <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                  </c:if>
                </form>
              </td>
              <td>${free.createdAt}</td>
            </c:if>
            <!-- 삭제된 게시글 -->
            <c:if test="${free.status == 0}">
              <td colspan="3">
                삭제된 게시글입니다.
              </td>
            </c:if>
          </tr>
          <tr class="blind write_tr">
            <td colspan="4">
              <form method="post" action="${contextPath}/free/addReply.do">
                <div class="input-group mb-3">
                  <label class="input-group-text" id="inputGroup-sizing-default">작성자</label>
                  <input type="text" name="email" value="${sessionScope.user.email}" readonly class="form-control">
                </div>
                <div class="input-group">
                  <label for="contents" class="input-group-text">내용</label>
                  <textarea name="contents" id="contents" class="form-control" aria-label="With textarea"></textarea>
                  <button type="submit" class="btn btn-primary btn-sm">댓글달기</button>
                </div>
                <div>
                  <input type="hidden" name="depth" value="${free.depth}">
                  <input type="hidden" name="groupNo" value="${free.groupNo}">
                  <input type="hidden" name="groupOrder" value="${free.groupOrder}">
                </div>
              </form>
            </td>
          </tr>
        </c:forEach>
      </tbody>
      <tfoot>
        <tr>
          <td colspan="4">${paging}</td>
        </tr>
      </tfoot>
    </table>
  </div>

</div>

<script>

  const fnAddResult = () => {
    let addResult = '${addResult}';
    if(addResult !== ''){
      if(addResult === '1'){
        alert('게시글이 등록되었습니다.');
      } else {
        alert('게시글이 등록되지 않았습니다.');
      }
    }
  }
  
  const fnBlind = () => {
    $('.btn_reply').click((ev) => {
      if('${sessionScope.user}' === ''){
        if(confirm('로그인이 필요한 기능입니다. 로그인할까요?')){
          location.href = '${contextPath}/user/login.form';
        } else {
          return;
        }
      }
      // 화살표 함수는 this 객체가 지원되지 않기 때문에
      // 이벤트 대상을 "이벤트 객체"의 "target" 속성으로 처리한다.
      let writeTr = $(ev.target).closest('.list').next();
      // class="blind"를 가진 상태 : 숨김 상태이므로 열어 준다.
      if(writeTr.hasClass('blind')){
        $('.write_tr').addClass('blind');  // 모든 작성화면 닫기
        writeTr.removeClass('blind');      // 현재 작성화면 열기
      }
      // class="blind"가 없는 상태 : 이미 열린 상태이므로 다시 숨긴다.
      else {
        writeTr.addClass('blind');
      }
    })
  }
  
  const fnAddReplyResult = () => {
    let addReplyResult = '${addReplyResult}';
    if(addReplyResult !== ''){
      if(addReplyResult === '1'){
        alert('댓글이 등록되었습니다.');
      } else {
        alert('댓글이 등록되지 않았습니다.');
      }
    }
  }

  const fnRemove = () => {
    $('.frm_remove').submit((ev) => {
      if(!confirm('게시글을 삭제할까요?')){
        ev.preventDefault();
        return;
      }
    })
  }
  
  const fnRemoveResult = () => {
    let removeResult = '${removeResult}';
    if(removeResult !== ''){
      if(removeResult === '1'){
        alert('게시글이 삭제되었습니다.');
      } else {
        alert('게시글이 삭제되지 않았습니다.');
      }
    }
  }
  
  fnAddResult();
  fnBlind();
  fnAddReplyResult();
  fnRemove();
  fnRemoveResult();

</script>

<%@ include file="../layout/footer.jsp" %>