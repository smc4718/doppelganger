<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="dt" value="<%=System.currentTimeMillis()%>" />

<jsp:include page="../layout/header.jsp">
  <jsp:param value="회원가입" name="title"/>
</jsp:include>

<script src="${contextPath}/resources/js/user_join.js?dt=${dt}"></script>

<div class="wrap wrap_7">

  <h1 class="title">회원가입</h1>

  <form id="frm_join" method="post" action="${contextPath}/user/join.do">
    
    <div class="row mb-2">
      <label for="email" class="col-sm-3 col-form-label">이메일</label>
      <div class="col-sm-6"><input type="text" name="email" id="email" placeholder="이메일" class="form-control"></div>
      <div class="col-sm-3 d-grid gap-2"><button type="button" id="btn_get_code" class="btn btn-outline-success">인증코드받기</button></div>
      <div class="col-sm-3"></div>
      <div class="col-sm-9" id="msg_email"></div>
    </div>
    
    <div class="row mb-2">
      <div class="col-sm-8"><input type="text" id="code" class="form-control" placeholder="인증코드입력" disabled></div>
      <div class="col-sm-4 d-grid gap-2"><button type="button" class="btn btn-outline-secondary" id="btn_verify_code" disabled>인증하기</button></div>
    </div>
    
    <hr class="my-3">
    
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
    
    <hr class="my-3">
    
    <div class="row mb-2">
      <label for="name" class="col-sm-3 col-form-label">이름</label>
      <div class="col-sm-9"><input type="text" name="name" id="name" class="form-control"></div>
      <div class="col-sm-3"></div>
      <div class="col-sm-9 mb-3" id="msg_name"></div>
    </div>

    <div class="row mb-2">
      <label for="mobile" class="col-sm-3 col-form-label">휴대전화번호</label>
      <div class="col-sm-9"><input type="text" name="mobile" id="mobile" class="form-control"></div>
      <div class="col-sm-3"></div>
      <div class="col-sm-9 mb-3" id="msg_mobile"></div>
    </div>

    <div class="row mb-2">
      <label class="col-sm-3 form-label">성별</label>
      <div class="col-sm-3">
        <input type="radio" name="gender" value="NO" id="none" class="form-check-input" checked>
        <label class="form-check-label" for="none">선택안함</label>
      </div>
      <div class="col-sm-3">
        <input type="radio" name="gender" value="M" id="man" class="form-check-input">
        <label class="form-check-label" for="man">남자</label>
      </div>
      <div class="col-sm-3">
        <input type="radio" name="gender" value="F" id="woman" class="form-check-input">
        <label class="form-check-label" for="woman">여자</label>
      </div>
    </div>
    
    <hr class="my-3">
    
    <div class="row mb-2">
      <label for="postcode" class="col-sm-3 col-form-label">주소</label>
      <div class="col-sm-4"><input type="text" name="postcode" id="postcode" class="form-control" onclick="execDaumPostcode()" placeholder="우편번호" readonly></div>
      <div class="col-sm-5"><input type="button" class="btn btn-outline-success" onclick="execDaumPostcode()" value="우편번호 찾기"></div>
    </div>
    
    <div class="row mb-2">
      <div class="col-sm-6"><input type="text" name="roadAddress" id="roadAddress" class="form-control" placeholder="도로명주소" readonly></div>
      <div class="col-sm-6"><input type="text" name="jibunAddress" id="jibunAddress" class="form-control" placeholder="지번주소" readonly></div>
    </div>
    <div class="col-sm-12"><span id="guide" style="color:#999;display:none"></span></div>
    <div class="row mb-2">
      <div class="col-sm-6"><input type="text" name="detailAddress" id="detailAddress" class="form-control" placeholder="상세주소"></div>
      <div class="col-sm-6"><input type="text" id="extraAddress" class="form-control" placeholder="참고항목"></div>
    </div>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>

      function execDaumPostcode() {
        new daum.Postcode({
          oncomplete: function(data) {
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
              extraRoadAddr += data.bname;
            }

            if(data.buildingName !== '' && data.apartment === 'Y'){
              extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }

            if(extraRoadAddr !== ''){
              extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById("roadAddress").value = roadAddr;
            document.getElementById("jibunAddress").value = data.jibunAddress;
            
            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            if(roadAddr !== ''){
              document.getElementById("extraAddress").value = extraRoadAddr;
            } else {
              document.getElementById("extraAddress").value = '';
            }

            var guideTextBox = document.getElementById("guide");
            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if(data.autoRoadAddress) {
              var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
              guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
              guideTextBox.style.display = 'block';
            } else if(data.autoJibunAddress) {
              var expJibunAddr = data.autoJibunAddress;
              guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
              guideTextBox.style.display = 'block';
            } else {
              guideTextBox.innerHTML = '';
              guideTextBox.style.display = 'none';
            }
          }
        }).open();
      }
    </script>
    
    <div class="mt-3 text-center">
      <input type="hidden" name="event" value="${event}">
      <button type="submit" class="btn btn-primary">회원가입하기</button>
    </div>
    
  </form>

</div>

<%@ include file="../layout/footer.jsp" %>